# frozen_string_literal: true

require_relative 'schedule/base_command'
require_relative 'schedule/list_command'
require_relative 'schedule/cancel_command'

module Superbot
  module Cloud
    module CLI
      class ScheduleCommand < Clamp::Command
        include Superbot::Cloud::Validations

        subcommand ['list'], "List your schedules", Schedule::ListCommand
        subcommand ['cancel'], "Cancel your schedule", Schedule::CancelCommand

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
