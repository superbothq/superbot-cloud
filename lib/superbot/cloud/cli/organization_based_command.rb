# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class OrganizationBasedCommand < LoginRequiredCommand
        option ["--org"], "ORGANIZATION", "Organization to to take actions on", attribute_name: :organization
      end
    end
  end
end
