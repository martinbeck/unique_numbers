# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unique_numbers/version'

Gem::Specification.new do |spec|
  spec.name          = "unique_numbers"
  spec.version       = UniqueNumbers::VERSION
  spec.authors       = ["Martin Beck"]
  spec.email         = ["mail@martinbeck.net"]
  spec.summary       = %q{Provides race-condition-free unique number generators for ActiveRecord.}
  spec.description   = %q{Provides race-condition-free unique number generators for ActiveRecord.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel', '>= 3.0.0'
  spec.add_dependency 'activesupport', '>= 3.0.0'
  
  spec.add_development_dependency 'activerecord', '>= 3.0.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'shoulda'
  spec.add_development_dependency 'mocha', '= 0.9.8'
  spec.add_development_dependency 'bourne'
  spec.add_development_dependency 'timecop'
end
