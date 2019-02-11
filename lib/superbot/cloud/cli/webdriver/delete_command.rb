# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Webdriver
        class DeleteCommand < BaseCommand
          option ['--all'], :flag, "Delete all active sessions"
          parameter "SESSION_ID ...", "webdriver session ID", required: false

          def execute
            delete_session
          end

          def delete_session
            if all?
              webdriver_sessions = Superbot::Cloud::Api.request(
                :webdriver_session_list,
                params: { organization_name: organization, 'aasm_state[]': %w[idle proxying] }
              ).fetch(:webdriver_sessions, [])

              abort "All sessions are finished" if webdriver_sessions.empty?

              @session_id_list = webdriver_sessions&.map { |session| session[:session_id] }
            elsif session_id_list.empty?
              signal_usage_error "parameter SESSION_ID is required"
            end

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
