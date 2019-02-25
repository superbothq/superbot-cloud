# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Organization
        class ListCommand < BaseCommand
          def execute
            list_organizations
          end

          def list_organizations
            default_org = Superbot::Cloud.credentials[:organization]
            api_response = Superbot::Cloud::Api.request(:organization_list)

            puts "Your organizations:"
            puts(api_response.map { |org| org[:name] == default_org ? "#{org[:name]} (default)" : org[:name] })
          end
        end
      end
    end
  end
end
