# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Organization
        class DefaultCommand < BaseCommand
          parameter "NAME", "Organization name", required: true

          def execute
            organization = Superbot::Cloud::Api.request(:get_organization, params: { name: name })
            new_credentials = Superbot::Cloud.credentials.merge(organization: organization[:name])
            Superbot::Cloud.save_credentials(new_credentials)

            puts "Default organization: #{Superbot::Cloud.credentials[:organization]}"
          end
        end
      end
    end
  end
end
