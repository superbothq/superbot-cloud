# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class LogoutCommand < Clamp::Command
        def execute
          Superbot::Cloud.remove_credentials
          puts "Succesfully loged out."
        end
      end
    end
  end
end
