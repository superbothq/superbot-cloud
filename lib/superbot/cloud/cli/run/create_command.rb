# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Run
        class CreateCommand < BaseCommand
          parameter "NAME", "the name of the test to delete", required: true
          option ['--region'], 'REGION', 'Region for remote webdriver'

          def execute
            Superbot::Cloud::Api.request(:create_interactive_run, params: run_params)
            puts "Cloud interactive run has been created"
          end

          def run_params
            {
              organization_name: organization,
              test_name: name,
              region: region
            }.compact
          end
        end
      end
    end
  end
end
