# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Member
        class ListCommand < BaseCommand
          include Superbot::Cloud::Validations

          def execute
            require_login
            list_members
          end

          def list_members
            api_response = Superbot::Cloud::Api.request(:organization_members_list, params: { organization_name: @organization })
            abort api_response[:error] if api_response[:error]
            puts "Organization: #{api_response[:organization]}"
            puts "Members:"
            puts(api_response[:members].map { |m| m[:username] })
          end
        end
      end
    end
  end
end
