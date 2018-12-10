# frozen_string_literal: true

require_relative 'organization/list_command'

module Superbot
  module Cloud
    module CLI
      class OrganizationCommand < Clamp::Command
        subcommand ['list'], "List user organizations from the cloud", Organization::ListCommand

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
