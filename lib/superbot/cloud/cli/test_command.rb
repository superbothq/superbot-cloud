# frozen_string_literal: true

require_relative 'test/base_command'
require_relative 'test/list_command'
require_relative 'test/upload_command'
require_relative 'test/download_command'
require_relative 'test/delete_command'
require_relative 'test/schedule_command'

module Superbot
  module Cloud
    module CLI
      class TestCommand < Clamp::Command
        include Superbot::Cloud::Validations

        subcommand ['list'], "List user tests from the cloud", Test::ListCommand
        subcommand ['upload'], "Upload test to the cloud", Test::UploadCommand
        subcommand ['download'], "Download test from the cloud", Test::DownloadCommand
        subcommand ['delete'], "Delete test from the cloud", Test::DeleteCommand
        subcommand ['schedule'], "Schedule a test", Test::ScheduleCommand

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
