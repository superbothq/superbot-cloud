# frozen_string_literal: true

require_relative 'cloud/login_command'
require_relative 'cloud/version_command'

module Superbot
  module CLI
    class CloudCommand < Clamp::Command
      subcommand ['version'], 'Superbot cloud version', Cloud::VersionCommand
      subcommand ['login'], "Login to supervisor cloud", Cloud::LoginCommand
      # subcommand ['org list'], "List user organizations from the cloud", Cloud::Organization::ListCommand

      def self.run
        super
      rescue StandardError => exc
        warn exc.message
        warn exc.backtrace.join("\n")
      end
    end
  end
end
