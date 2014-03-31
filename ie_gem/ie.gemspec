# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ie/version'

Gem::Specification.new do |spec|
  spec.name          = "ie"
  spec.version       = IE::VERSION
  spec.authors       = ["Nii"]
  spec.email         = ["tetteh_ideaz@gmail.com"]
  spec.summary       = "Summary"
  spec.description   = "Description"
  spec.homepage      = "https://rubygems.org/gems/ie"
  spec.license       = "TI"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.5.3'
  spec.add_development_dependency 'rake', '~> 0.9.6'
  spec.add_development_dependency 'rspec', '~> 0.9.4'
  spec.add_development_dependency 'curb', '~> 0.8.5'
  spec.add_development_dependency 'capybara', '2.1.0'
end
