# frozen_string_literal: true

require_relative 'validations'
require_relative 'login_command'
require_relative 'version_command'
require_relative 'organization_command'
require_relative 'test_command'
require_relative 'webdriver_command'
require_relative 'member_command'

module Superbot
  module Cloud
    module CLI
      class RootCommand < Clamp::Command
        subcommand ['version'], 'Superbot cloud version', VersionCommand
        subcommand ['login'], 'Login to superbot cloud', LoginCommand
        subcommand(['org'], 'Manage your organizations', OrganizationCommand)
        subcommand ['test'], "Manage your tests", TestCommand
        subcommand ['webdriver'], "Manage your webdriver sessions", WebdriverCommand
        subcommand ['member'], "Manage your organization members", MemberCommand

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
end
