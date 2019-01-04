# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Test
        class ListCommand < BaseCommand
          def execute
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
