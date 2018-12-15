# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Member
        class AddCommand < BaseCommand
          include Superbot::Cloud::Validations

          parameter "USERNAME", "Username of a user to add", required: true

          def execute
            require_login
            add_member
          end

          def add_member
            api_response = Superbot::Cloud::Api.request(:organization_add_member, params: { organization_name: organization, username: username })
            puts "Succesfully added %<username>s to %<organization>s organization" % api_response.slice(:username, :organization)
          end
        end
      end
    end
  end
end
