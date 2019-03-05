# frozen_string_literal: true

require_relative 'test/base_command'
require_relative 'test/list_command'
require_relative 'test/upload_command'
require_relative 'test/download_command'
require_relative 'test/delete_command'

module Superbot
  module Cloud
    module CLI
      class TestCommand < LoginRequiredCommand
        subcommand ['list'], "List user's tests from the cloud", Test::ListCommand
        subcommand ['upload'], "Upload a test to the cloud", Test::UploadCommand
        subcommand ['download'], "Download a test from the cloud", Test::DownloadCommand
        subcommand ['delete'], "Delete a test from the cloud", Test::DeleteCommand
      end
    end
  end
end
