# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class OrganizationBasedCommand < LoginRequiredCommand
        option ["--org"], "ORGANIZATION", "Name of organization to take action on", environment_variable: "SUPERBOT_ORG", required: ENV['SUPERBOT_TOKEN'].to_s.empty?, attribute_name: :organization
      end
    end
  end
end
