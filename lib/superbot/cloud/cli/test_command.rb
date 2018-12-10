# frozen_string_literal: true

require_relative 'test/list_command'
require_relative 'test/upload_command'
require_relative 'test/delete_command'

module Superbot
  module Cloud
    module CLI
      class TestCommand < Clamp::Command
        subcommand ['list'], "List user tests from the cloud", Test::ListCommand
        subcommand ['upload'], "Upload test to the cloud", Test::UploadCommand
        subcommand ['delete'], "Delete test from the cloud", Test::DeleteCommand

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
