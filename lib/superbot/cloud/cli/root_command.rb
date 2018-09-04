# frozen_string_literal: true

require_relative 'cloud_command'

module Superbot
  module CLI
    class RootCommand < Clamp::Command
      subcommand ['cloud'], "Show cloud commands", CloudCommand
    end
  end
end
