# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_hashes/version'

Gem::Specification.new do |spec|
  spec.name    = "ruby_hashes"
  spec.version = RubyHashes::VERSION
  spec.authors = ["Kiyoshi '13k' Murata"]
  spec.email   = ["kbmurata@gmail.com"]

  spec.summary     = %q{Convert Ruby old-style from/to new-style hashes.}
  spec.description = %q{Convert Ruby old-style from/to new-style hashes.}
  spec.homepage    = "https://github.com/commita/ruby_hashes"
  spec.license     = "MIT"

  spec.platform = Gem::Platform::RUBY

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://localhost"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir["{exe,lib}/**/*", "README.md", "LICENSE.txt"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "parser", "~> 2.2"
  spec.add_dependency "activesupport", "~> 4.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "pry-suite"
end
