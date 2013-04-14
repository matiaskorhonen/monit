# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "monit/version"

Gem::Specification.new do |gem|
  gem.authors     = ["Matias Korhonen"]
  gem.email       = ["me@matiaskorhonen.fi"]
  gem.homepage    = "http://github.com/k33l0r/monit"
  gem.summary     = "Connect to Monit"
  gem.description = "Retrieve server information from Monit."

  gem.name          = "monit"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.version       = Monit::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec", "~> 2.9.0"

  gem.add_runtime_dependency "nokogiri", "~> 1.5.2"
  gem.add_runtime_dependency "activesupport", "~> 3.0.15"
end
