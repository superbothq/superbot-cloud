# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Member
        class ListCommand < BaseCommand
          def execute
            list_members
          end

          def list_members
            api_response = Superbot::Cloud::Api.request(:member_list, params: { organization_name: @organization })
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
