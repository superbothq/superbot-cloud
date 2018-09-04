# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      class LoginCommand < Clamp::Command
        def execute
          puts "This should start a local web server with login to supervisor cloud"
        end
      end
    end
  end
end
