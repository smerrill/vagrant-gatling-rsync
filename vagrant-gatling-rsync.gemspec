# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-gatling-rsync/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-gatling-rsync"
  spec.version       = VagrantPlugins::GatlingRsync::VERSION
  spec.authors       = ["Steven Merrill"]
  spec.email         = ["steven.merrill@gmail.com"]
  spec.summary       = %q{A lighter-weight Vagrant plugin for watching and rsyncing directories.}
  spec.description   = %q{The gatling-rsync plugin runs on Mac and Linux and is far less CPU-intensive than the built-in rsync-auto.}
  spec.homepage      = ""
  spec.license       = "MIT"

  # @TODO: Remove example files from the built gem.
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  # Make Vagrant work on Linux for development.
  spec.add_development_dependency "json", "~> 1.8.1"
end
