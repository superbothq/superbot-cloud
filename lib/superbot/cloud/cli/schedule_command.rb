# frozen_string_literal: true

require_relative 'schedule/base_command'
require_relative 'schedule/list_command'
require_relative 'schedule/cancel_command'
require_relative 'schedule/create_command'

module Superbot
  module Cloud
    module CLI
      class ScheduleCommand < LoginRequiredCommand
        subcommand ['create'], "Create new scheduled run", Schedule::CreateCommand
        subcommand ['list'], "List your schedules", Schedule::ListCommand
        subcommand ['cancel'], "Cancel your schedule", Schedule::CancelCommand
      end
    end
  end
end
