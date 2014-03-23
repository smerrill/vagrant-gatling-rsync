# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant/gatling/rsync/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-gatling-rsync"
  spec.version       = Vagrant::Gatling::Rsync::VERSION
  spec.authors       = ["Steven Merrill"]
  spec.email         = ["steven.merrill@gmail.com"]
  spec.summary       = %q{A lighter-weight Vagrant plugin for watching and rsyncing directories.}
  spec.description   = %q{The gatling-rsync plugin run on Mac (and soon on Linux) and is far less CPU-intensive than the built-in 'vagrant rsync-auto' plugin, at the cost of possibly rsyncing more often.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
