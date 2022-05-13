# frozen_string_literal: true

module JSRailsRoutes
  module SpecHelper
    class TestApp < ::Rails::Application
      config.root = ::File.expand_path('../../tmp/test_app', __dir__)

      routes.draw do
        resources :blogs
        resources :users
      end
    end

    class TestEngine < ::Rails::Engine
      def self.name
        'Admin::Engine'
      end

      routes.draw do
        resources :notes
        resources :photos
      end
    end

    class EmptyEngine < ::Rails::Engine
      def self.name
        'Empty::Engine'
      end

      routes.draw {} # rubocop:disable Lint/EmptyBlock
    end
  end
end
