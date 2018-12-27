# frozen_string_literal: true

require_relative 'organization/list_command'

module Superbot
  module Cloud
    module CLI
      class OrganizationCommand < LoginRequiredCommand
        subcommand ['list'], "List user organizations from the cloud", Organization::ListCommand
      end
    end
  end
end
