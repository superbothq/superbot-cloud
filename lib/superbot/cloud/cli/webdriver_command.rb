# frozen_string_literal: true

require_relative 'webdriver/list_command'
require_relative 'webdriver/delete_command'

module Superbot
  module Cloud
    module CLI
      class WebdriverCommand < Clamp::Command
        include Superbot::Cloud::Validations

        subcommand ['list'], "List all webdriver sessions", Webdriver::ListCommand
        subcommand ['delete'], "Terminate and finish specific session", Webdriver::DeleteCommand

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
