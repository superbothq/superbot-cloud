# frozen_string_literal: true

require_relative 'webdriver/list_command'
require_relative 'webdriver/delete_command'

module Superbot
  module Cloud
    module CLI
      class WebdriverCommand < LoginRequiredCommand
        subcommand ['list'], "List all webdriver sessions", Webdriver::ListCommand
        subcommand ['delete'], "Terminate and finish specific session", Webdriver::DeleteCommand
      end
    end
  end
end
