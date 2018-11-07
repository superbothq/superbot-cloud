# frozen_string_literal: true

require_relative "cloud/validations"
require_relative 'cloud/login_command'
require_relative 'cloud/version_command'
require_relative 'cloud/organization_command'
require_relative 'cloud/test_command'

module Superbot
  module CLI
    class CloudCommand < Clamp::Command
      subcommand ['version'], 'Superbot cloud version', Cloud::VersionCommand
      subcommand ['login'], 'Login to superbot cloud', Cloud::LoginCommand
      subcommand(['org'], 'Manage your organizations', Cloud::OrganizationCommand) if ENV['SUPERBOT_FEAT_CLOUD_ORG'] == 'true'
      subcommand ['test'], "Manage your tests", Cloud::TestCommand if ENV['SUPERBOT_FEAT_CLOUD_TEST'] == 'true'

      option ['-v', '--version'], :flag, "Show version information" do
        puts Superbot::Cloud::VERSION
        exit 0
      end

      def self.run
        super
      rescue StandardError => exc
        warn exc.message
        warn exc.backtrace.join("\n")
      end
    end
  end
end
