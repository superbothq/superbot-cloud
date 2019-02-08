# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Token
        class RevokeCommand < BaseCommand
          parameter "TOKEN", "Access token to remove"

          def execute
            revoke_token
          end

          def revoke_token
            api_response = Superbot::Cloud::Api.request(:revoke_access_token, params: { organization_name: organization, token: token })
            puts "Token was successfully revoked"
          end
        end
      end
    end
  end
end
