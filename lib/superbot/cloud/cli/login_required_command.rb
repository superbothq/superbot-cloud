# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class LoginRequiredCommand < Clamp::Command
        include Superbot::Cloud::Validations

        def run(args)
          require_login
          super
        end

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
