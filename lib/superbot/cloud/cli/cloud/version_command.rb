# frozen_string_literal: true

module Superbot
  module CLI
    module Cloud
      class VersionCommand < Clamp::Command
        def execute
          puts Superbot::Cloud::VERSION
        end
      end
    end
  end
end
