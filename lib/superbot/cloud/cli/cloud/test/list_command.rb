# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      module Test
        class ListCommand < Clamp::Command
          option ["-o", "--org"], "ORGANIZATION", "Organization to list tests for", attribute_name: :organization

          def execute
            abort "You are not logged in, use `superbot cloud login` to login" unless Superbot::Cloud.credentials
            list_tests
          end

          def list_tests
            res = Superbot::Cloud::Api.request(:test_list, params: { organization_name: organization })
            parsed_body = JSON.parse(res.body, symbolize_names: true)
            abort parsed_body[:errors] unless res.code == '200'
            puts "Organization: #{parsed_body[:organization]}"
            puts "Tests:"
            parsed_body[:tests].each do |test|
              puts test[:title]
            end
          end
        end
      end
    end
  end
end
