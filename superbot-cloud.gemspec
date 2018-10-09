
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "superbot/cloud/version"

Gem::Specification.new do |spec|
  spec.name          = "superbot-cloud"
  spec.version       = Superbot::Cloud::VERSION
  spec.authors       = ["DeeMak13"]
  spec.email         = ["dima.m@active-bridge.com"]

  spec.summary       = %q{Superbot Cloud}
  spec.homepage      = "https://github.com/superbothq/superbot-cloud"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  puts spec.files
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'multipart-post'

  spec.add_runtime_dependency "superbot"
  spec.add_runtime_dependency "clamp", "1.2.1"
  spec.add_runtime_dependency "zaru", "0.2.0"
  spec.add_runtime_dependency "sinatra", "2.0.3"
  spec.add_runtime_dependency "launchy", "2.4.3"
  spec.add_runtime_dependency "sinatra-silent", "0.0.1"
  spec.add_runtime_dependency "marcel"

  spec.add_development_dependency "kommando", "~> 0.1"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.53"
end
