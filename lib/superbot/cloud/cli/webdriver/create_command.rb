# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Webdriver
        class CreateCommand < BaseCommand
          option ['--region'], 'REGION', 'Region for remote webdriver'
          option ['--local'], :flag, "Local dev webdriver environment", hidden: true

          def execute
            create_webdriver
          end

          def create_webdriver
            request_body = {
              organization_name: organization,
              desiredCapabilities: {
                browserName: 'chrome',
                superOptions: {}
              }
            }
            request_body[:desiredCapabilities][:superOptions][:region] = region if region
            puts "Creating webdriver session..."
            puts "Please wait for Session ID or press [ctrl/cmd + c] to exit"
            session = Excon.post(
              [Superbot.webdriver_endpoint(local? ? 'local_cloud' : 'cloud'), 'wd/hub/session'].join('/'),
              persistent: true,
              headers: { 'Authorization' => Superbot::Cloud.authorization_header, 'Content-Type' => 'application/json' },
              body: request_body.to_json,
              connect_timeout: 3,
              read_timeout: 500,
              write_timeout: 500
            )
            parsed_response = JSON.parse(session.body)
            puts parsed_response['error'] || parsed_response['sessionId']
          end
        end
      end
    end
  end
end
