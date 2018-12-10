# frozen_string_literal: true

module Superbot
  module Cloud
    module CLI
      class VersionCommand < Clamp::Command
        def execute
          puts Superbot::Cloud::VERSION
        end
      end
    end
  end
end
