# frozen_string_literal: true

require_relative 'webdriver/list_command'
require_relative 'webdriver/delete_command'

module Superbot
  module CLI
    module Cloud
      class WebdriverCommand < Clamp::Command
        subcommand ['list'], "List all webdriver sessions", Cloud::Webdriver::ListCommand
        subcommand ['delete'], "Terminate and finish specific session", Cloud::Webdriver::DeleteCommand

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
