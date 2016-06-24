$: << File.expand_path('../lib', __FILE__)

require 'js_rails_routes/version'

Gem::Specification.new do |spec|
  spec.name            = 'js_rails_routes'
  spec.version         = JSRailsRoutes::VERSION
  spec.authors         = ['Yuku Takahashi']
  spec.email           = ['taka84u9@gmail.com']
  spec.summary         = 'Generate a ES6 module that contains Rails routes.'
  spec.homepage        = 'https://github.com/yuku-t/js_rails_routes'
  spec.license         = 'MIT'
  spec.files           = `git ls-files -z`.split("\x0")
  spec.require_paths   = ['lib']
  spec.add_dependency 'rails', '>= 3'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
