# frozen_string_literal: true

require_relative 'organization/base_command'
require_relative 'organization/list_command'
require_relative 'organization/default_command'

module Superbot
  module Cloud
    module CLI
      class OrganizationCommand < LoginRequiredCommand
        subcommand ['list'], "List user organizations from the cloud", Organization::ListCommand
        subcommand ['default'], "Set default organization for CLI", Organization::DefaultCommand
      end
    end
  end
end
