# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Organization
        class ListCommand < Clamp::Command
          def execute
            list_organizations
          end

          def list_organizations
            api_response = Superbot::Cloud::Api.request(:organization_list)
            puts(api_response.map { |org| org[:name] })
          end
        end
      end
    end
  end
end
