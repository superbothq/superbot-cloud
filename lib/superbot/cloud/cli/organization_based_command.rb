# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class OrganizationBasedCommand < LoginRequiredCommand
        option ["--org"], "ORGANIZATION", "Name of organization to take action on", environment_variable: "SUPERBOT_ORG", attribute_name: :organization, default: Superbot::Cloud.credentials&.fetch(:organization, nil)
      end
    end
  end
end
