# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib', __dir__)

require 'js_rails_routes/version'

Gem::Specification.new do |spec|
  spec.name            = 'js_rails_routes'
  spec.version         = JSRailsRoutes::VERSION
  spec.authors         = ['Yuku Takahashi']
  spec.email           = ['yuku@qiita.com']
  spec.summary         = 'Generate a ES6 module that contains Rails routes.'
  spec.homepage        = 'https://github.com/increments/js_rails_routes'
  spec.license         = 'MIT'
  spec.files           = `git ls-files -z`.split("\x0")
  spec.require_paths   = ['lib']
  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency 'rails', '>= 3.2'
  spec.add_development_dependency 'bundler', '>= 1.16'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.60.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.30.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
end
