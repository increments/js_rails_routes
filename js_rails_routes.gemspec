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
  spec.required_ruby_version = '>= 3.2.0'

  spec.add_dependency 'rails', '>= 6.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
