# frozen_string_literal: true

$LOAD_PATH << File.expand_path('../lib', __dir__)

require 'simplecov'
SimpleCov.start

require 'rails/all'
require 'js_rails_routes'

class TestApp < Rails::Application
  config.root = File.expand_path('test_app', __dir__)

  routes.draw do
    resources :blogs
    resources :users
  end
end

module Admin
  class Engine < ::Rails::Engine
    routes.draw do
      resources :notes
      resources :photos
    end
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
