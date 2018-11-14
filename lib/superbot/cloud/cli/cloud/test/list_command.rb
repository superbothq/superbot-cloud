# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      module Test
        class ListCommand < Clamp::Command
          include Superbot::Cloud::Validations

          option ["-o", "--org"], "ORGANIZATION", "Organization to list tests for", attribute_name: :organization

          def execute
            require_login
            list_tests
          end

          def list_tests
            api_response = Superbot::Cloud::Api.request(:test_list, params: { organization_name: organization })
            abort api_response[:error] if api_response[:error]
            puts "Organization: #{api_response[:organization]}"
            puts "Tests:"
            api_response[:tests].each do |test|
              puts(test[:name], test[:files].map { |f| "- #{f[:filename]}" })
            end
          end
        end
      end
    end
  end
end
