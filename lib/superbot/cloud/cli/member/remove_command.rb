# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Member
        class RemoveCommand < BaseCommand
          include Superbot::Cloud::Validations

          parameter "USERNAME", "Username of a user to remove"

          def execute
            require_login
            remove_member
          end

          def remove_member
            api_response = Superbot::Cloud::Api.request(:organization_remove_member, params: { organization_name: organization, username: username })
            puts "Member successfully removed from organization"
          end
        end
      end
    end
  end
end
