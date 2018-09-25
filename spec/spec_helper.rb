require "bundler/setup"
require "superbot"
require "superbot/cloud"
require "kommando"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def superbot_cloud(*cmds)
  Kommando.new("exe/superbot-cloud #{cmds.join(" ")}").tap { |k| k.run }
end
