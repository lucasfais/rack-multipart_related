# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rack/multipart_related'

Gem::Specification.new do |s|
  s.name        = "rack-multipart_related"
  s.version     = Rack::MultipartRelated::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lucas Fais", "Marcelo Manzan"]
  s.email       = ["lucasfais@gmail.com", "manzan@gmail.com"]
  s.homepage    = "https://github.com/lucasfais/rack-multipart_related"
  s.summary     = %q{Makes easy to handle mutipart/related requests.}
  s.description = %q{It's a rack middleware to parse multipart/related requests and rebuild a simple/merged parameters hash.}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rack-multipart_related"

  s.add_development_dependency "step-up"
  s.add_development_dependency "mocha" 

  excepts = %w[
    .gitignore
    rack-multipart_related.gemspec
  ]
  tests = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.files              = `git ls-files`.split("\n") - excepts - tests
  s.test_files         = tests
  s.require_paths      = ["lib"]
end