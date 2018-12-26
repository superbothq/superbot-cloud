# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      module Schedule
        class BaseCommand < Clamp::Command
          option ["--org"], "ORGANIZATION", "Organization to to take actions on", attribute_name: :organization
        end
      end
    end
  end
end
