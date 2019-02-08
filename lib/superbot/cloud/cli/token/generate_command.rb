# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Token
        class GenerateCommand < BaseCommand
          parameter "NAME", "Token title", required: true

          def execute
            generate_token
          end

          def generate_token
            api_response = Superbot::Cloud::Api.request(:create_access_token, params: { organization_name: organization, name: name })
            puts api_response[:token]
          end
        end
      end
    end
  end
end
