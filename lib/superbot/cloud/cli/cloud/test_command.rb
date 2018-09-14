# frozen_string_literal: true

require_relative 'test/list_command'
require_relative 'test/upload_command'

module Superbot
  module CLI
    module Cloud
      class TestCommand < Clamp::Command
        subcommand ['list'], "List user tests from the cloud", Cloud::Test::ListCommand
        subcommand ['upload'], "Upload tests to the cloud", Cloud::Test::UploadCommand

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
