# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Token
        class ListCommand < BaseCommand
          OUTPUT_HEADERS = {
            name: "Title",
            token: "Token",
            scope: "API scope"
          }.freeze

          def execute
            list_tokens
          end

          def list_tokens
            api_response = Superbot::Cloud::Api.request(:access_token_list, params: { organization_name: organization })
            puts "Organization: #{api_response[:organization]}"
            puts "Access Tokens:"
            puts(api_response[:access_tokens].map { |m| m[:username] })

            puts "Organization: #{api_response[:organization]}"
            puts OUTPUT_HEADERS.values.map { |header| header.ljust(35) }.join
            puts ''.ljust(35 * OUTPUT_HEADERS.length, '-')
            api_response[:access_tokens].each do |webdriver_session|
              puts webdriver_session.slice(*OUTPUT_HEADERS.keys).values.map { |v| v.to_s.ljust(35) }.join
            end
          end
        end
      end
    end
  end
end
