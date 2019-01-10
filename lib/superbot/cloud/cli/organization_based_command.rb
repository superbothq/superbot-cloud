# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class OrganizationBasedCommand < LoginRequiredCommand
        option ["--org"], "ORGANIZATION", "Name of organization to take action on", required: true, attribute_name: :organization
      end
    end
  end
end
