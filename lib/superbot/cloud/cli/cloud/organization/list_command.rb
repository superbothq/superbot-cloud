# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      module Organization
        class ListCommand < Clamp::Command
          include Superbot::Cloud::Validations

          def execute
            require_login
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
