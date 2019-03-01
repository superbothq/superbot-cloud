# frozen_string_literal: true

module Superbot
  module Cloud
    module Validations
      def require_login
        return if Superbot::Cloud.credentials || ENV['SUPERBOT_TOKEN']

        abort "You are not logged in, use `superbot cloud login` to login"
      end
    end
  end
end
