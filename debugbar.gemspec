# frozen_string_literal: true

require_relative "lib/debugbar/version"

Gem::Specification.new do |spec|
  spec.name = "debugbar"
  spec.version = Debugbar::VERSION
  spec.authors = ["Julien Bourdeau"]
  spec.email = ["julien@debugbar.dev"]

  spec.summary = "Powerful devtools for Ruby on Rails"
  spec.description = "Get a better understanding of your application performance and behavior (SQL queries, jobs, cache, routes, logs, etc)"
  spec.homepage = "https://debugbar.dev"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/julienbourdeau/debugbar"
  spec.metadata["changelog_uri"] = "https://debugbar.dev/changelog/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files_to_remove = %w[
    bin/ test/ spec/ features/ fixtures/
    client/
    .git .circleci appveyor Gemfile package.json package-lock.json .prettierrc
    release.sh build_client.sh build_demo.sh build_fixtures.rb build_gem.sh
    extension.zip
  ]

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*files_to_remove)
    end
  end.push("public/debugbar.js")

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails" #, ">= 7.1.1"
  spec.add_dependency "actioncable" #, ">= 7.1.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
