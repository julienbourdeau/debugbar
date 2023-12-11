# frozen_string_literal: true

require_relative "lib/debugbar/version"

Gem::Specification.new do |spec|
  spec.name = "debugbar"
  # spec.version = "0.1.0"
  spec.version = Debugbar::VERSION
  spec.authors = ["Julien Bourdeau"]
  spec.email = ["julien@julienbourdeau.com"]

  spec.summary = "Devtools for Rails: show information in a beautiful debugbar."
  spec.description = "SQL queries, jobs, cache, routes, views, logs, memory, redis, etc. See everything in the debugbar"
  spec.homepage = "https://www.julienbourdeau.com/docs/rails-debugbar-devtools"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/julienbourdeau/debugbar"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  # TODO: Add dependency on Rails, ActiveRecord, what else?
  spec.add_dependency "rails" #, ">= 7.1.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
