# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      module Webdriver
        class ListCommand < Clamp::Command
          include Superbot::Cloud::Validations
          OUTPUT_HEADERS = {
            session_id: "Session ID",
            created_at: "Created at",
            updated_at: "Last activity"
          }.freeze

          option %w[-q --quiet], :flag, "Only show webdriver session IDs"
          option %w[-a --all], :flag, "Show all the sessions (including finished)"

          def execute
            require_login
            list_sessions
          end

          def list_sessions
            states = all? ? nil : %w[idle proxying]
            api_response = Superbot::Cloud::Api.request(:webdriver_session_list, params: { 'aasm_state[]': states })
            abort api_response[:error] if api_response[:error]

            abort "No sessions found" if api_response[:webdriver_sessions].empty?

            if quiet?
              puts(api_response[:webdriver_sessions].map { |session| session[:session_id] })
            else
              puts OUTPUT_HEADERS.values.map { |header| header.ljust(35) }.join
              puts ''.ljust(35 * OUTPUT_HEADERS.length, '-')
              api_response[:webdriver_sessions].each do |webdriver_session|
                puts webdriver_session.slice(*OUTPUT_HEADERS.keys).values.map { |v| v.to_s.ljust(35) }.join
              end
            end
          end
        end
      end
    end
  end
end
