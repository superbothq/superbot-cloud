# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class LoginRequiredCommand < Clamp::Command
        Superbot::Cloud::Validations.require_login
      end
    end
  end
end
