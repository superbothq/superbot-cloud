# frozen_string_literal: true

module Superbot
  module Cloud
    module Validations
      def require_login
        return if Superbot::Cloud.credentials

        abort "You are not logged in, use `superbot cloud login` to login"
      end

      module_function :require_login
    end
  end
end
