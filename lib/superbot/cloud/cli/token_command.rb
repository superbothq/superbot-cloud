# frozen_string_literal: true

require_relative 'token/base_command'
require_relative 'token/generate_command'
require_relative 'token/revoke_command'
require_relative 'token/list_command'

module Superbot
  module Cloud
    module CLI
      class TokenCommand < LoginRequiredCommand
        subcommand ['generate'], "Generate new access token", Token::GenerateCommand
        subcommand ['revoke'], "Revoke token", Token::RevokeCommand
        subcommand ['list'], "List your organization access tokens", Token::ListCommand
      end
    end
  end
end
