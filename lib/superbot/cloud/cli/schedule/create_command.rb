# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Schedule
        class CreateCommand < BaseCommand
          parameter "NAME", "the name of the test to delete", required: true
          option ['--region'], 'REGION', 'Region for remote webdriver'
          option ['--when'], 'WHEN', "When to schedule a test (either asap or cron expression)", default: 'asap', attribute_name: :starts_at
          option ['--bots'], 'BOTS', 'Number of running cloud superbots', default: 1
          option ['--bots-delay'], 'BOTS_DELAY', 'Maximum delay before the bot starts'
          option ['--loop'], 'LOOP_COUNT', 'Number of runs for each bot', default: 1, attribute_name: :loop_count
          option ['--base-url'], 'BASE_URL', 'Base project URL for test'
          option ['--local-webdriver'], :flag, 'Use local webdriver instead of cloud webdriver api', hidden: true

          def execute
            schedule_test
          end

          def schedule_test
            Superbot::Cloud::Api.request(:schedule_test, params: schedule_params)
            puts "Cloud run has been scheduled"
          end

          def schedule_params
            {
              test_name: name,
              region: region,
              organization_name: organization,
              parallel: bots,
              bots_delay: bots_delay,
              starts_at: starts_at,
              loop: loop_count,
              webdriver_api: !local_webdriver?,
              base_url: base_url
            }.compact
          end
        end
      end
    end
  end
end
