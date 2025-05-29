# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib', __dir__)

require 'js_rails_routes/version'

Gem::Specification.new do |spec|
  spec.name            = 'js_rails_routes'
  spec.version         = JSRailsRoutes::VERSION
  spec.authors         = ['Qiita Inc.']
  spec.email           = ['engineers@qiita.com']
  spec.summary         = 'Generate a ES6 module that contains Rails routes.'
  spec.homepage        = 'https://github.com/increments/js_rails_routes'
  spec.license         = 'MIT'
  spec.files           = `git ls-files -z`.split("\x0")
  spec.require_paths   = ['lib']
  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'rails', '>= 6.0'
  spec.add_development_dependency 'bundler', '>= 1.16'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 1.75.8'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1', '!= 0.18.0', '!= 0.18.1', '!= 0.18.2', '!= 0.18.3', '!= 0.18.4', '!= 0.18.5', '!= 0.19.0', '!= 0.19.1' # rubocop:disable Metrics/LineLength
  spec.metadata['rubygems_mfa_required'] = 'true'
end
