# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Test
        class ListCommand < BaseCommand
          option %w[-q --quiet], :flag, "Only show test names"

          def execute
            list_tests
          end

          def list_tests
            api_response = Superbot::Cloud::Api.request(:test_list, params: { organization_name: organization })
            if quiet?
              puts(api_response[:tests].map { |test| test[:name] })
            else
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
end
