# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      module Webdriver
        class ListCommand < Clamp::Command
          include Superbot::Cloud::Validations

          def execute
            require_login
            list_sessions
          end

          def list_sessions
            api_response = Superbot::Cloud::Api.request(:webdriver_session_list)
            abort api_response[:error] if api_response[:error]
            puts "Webdriver Sessions:"
            headers = api_response[:webdriver_sessions].first&.keys
            puts headers.map { |field| field.to_s.upcase.ljust(35) }.join
            puts ''.ljust(35 * headers.length, '-')
            api_response[:webdriver_sessions].each do |webdriver_session|
              puts webdriver_session.values.map { |v| v.to_s.ljust(35) }.join
            end
          end
        end
      end
    end
  end
end
