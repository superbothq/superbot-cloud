# frozen_string_literal: true

require_relative 'member/base_command'
require_relative 'member/add_command'
require_relative 'member/remove_command'
require_relative 'member/list_command'

module Superbot
  module Cloud
    module CLI
      class MemberCommand < LoginRequiredCommand
        subcommand ['add'], "Add a member to organization", Member::AddCommand
        subcommand ['remove'], "Remove a member from organization", Member::RemoveCommand
        subcommand ['list'], "List organization's members", Member::ListCommand
      end
    end
  end
end
