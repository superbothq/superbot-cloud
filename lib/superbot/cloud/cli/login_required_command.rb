# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class LoginRequiredCommand < Clamp::Command
        Superbot::Cloud::Validations.require_login

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
