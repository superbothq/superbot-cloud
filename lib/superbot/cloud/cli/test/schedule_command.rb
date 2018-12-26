# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Test
        class ScheduleCommand < BaseCommand
          parameter "NAME", "the name of the test to delete", required: true
          option ['--region'], 'REGION', 'Region for remote webdriver'
          option ['--concurrency'], 'CONCURRENCY', 'Number of simultaneous user load', hidden: true

          def execute
            schedule_test
          end

          def schedule_test
            Superbot::Cloud::Api.request(:schedule_test, params: schedule_params)
            puts "Tests successfully scheduled"
          end

          def schedule_params
            {
              test_name: name,
              region: region,
              organization_name: organization,
              parallel: concurrency
            }.compact
          end
        end
      end
    end
  end
end
