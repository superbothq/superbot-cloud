# frozen_string_literal: true

require_relative 'organization/list_command'

module Superbot
  module CLI
    module Cloud
      class OrganizationCommand < Clamp::Command
        subcommand ['list'], "List user organizations from the cloud", Cloud::Organization::ListCommand

        def self.run
          super
        rescue StandardError => exc
          warn exc.message
          warn exc.backtrace.join("\n")
        end
      end
    end
  end
end
