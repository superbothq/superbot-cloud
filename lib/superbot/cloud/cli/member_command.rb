# frozen_string_literal: true

require_relative 'member/base_command'
require_relative 'member/add_command'
require_relative 'member/remove_command'
require_relative 'member/list_command'

module Superbot
  module Cloud
    module CLI
      class MemberCommand < Clamp::Command
        include Superbot::Cloud::Validations

        subcommand ['add'], "Add member to organization", Member::AddCommand
        subcommand ['remove'], "Remove member from organization", Member::RemoveCommand
        subcommand ['list'], "List your organization members", Member::ListCommand


        def self.run
          require_login
          super
        rescue StandardError => exc
          warn exc.message
          warn exc.backtrace.join("\n")
        end
      end
    end
  end
end
