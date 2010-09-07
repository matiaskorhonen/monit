# -*- encoding: utf-8 -*-
require File.expand_path("../lib/monit/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "monit"
  s.version     = Monit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matias Korhonen"]
  s.email       = ["matias@kiskolabs.com"]
  s.homepage    = "http://rubygems.org/gems/monit"
  s.summary     = "Connect to Monit"
  s.description = "Retrieve server information from Monit."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "monit"

  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "awesome_print"
  
  s.add_dependency "crack", "~> 0.1.8"
  s.add_dependency "curb", "~> 0.7.8"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
