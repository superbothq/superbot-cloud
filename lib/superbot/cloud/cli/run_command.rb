# frozen_string_literal: true

require_relative 'run/base_command'
require_relative 'run/create_command'
require_relative 'run/list_command'
require_relative 'run/abort_command'
require_relative 'run/scale_command'
require_relative 'run/console_command'

module Superbot
  module Cloud
    module CLI
      class RunCommand < LoginRequiredCommand
        subcommand ['create'], "Create new interactive test run", Run::CreateCommand
        subcommand ['list'], "List your interactive runs", Run::ListCommand
        subcommand ['abort'], "Abort run", Run::AbortCommand
        subcommand ['scale'], "Scale your interactive run", Run::ScaleCommand
        subcommand ['console'], "Interactive run console", Run::ConsoleCommand
      end
    end
  end
end
