# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Webdriver
        class DeleteCommand < BaseCommand
          parameter "SESSION_ID ...", "webdriver session ID", required: true

          def execute
            delete_session
          end

          def delete_session
            session_id_list.each do |session_id|
              Superbot::Cloud::Api.request(
                :delete_webdriver_session,
                params: {
                  session_id: session_id,
                  organization_name: organization
                }
              )

              puts "Webdriver session #{session_id} removal has been requested."
            rescue SystemExit
              p # skip to next webdriver session
            end
          end
        end
      end
    end
  end
end
