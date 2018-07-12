# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Builder do
  subject(:builder) { described_class.new(language, route_set_list) }

  include_context 'run in a sandbox'

  let(:language) { instance_double('JSRailsRoutes::Language::Base', handle_route_set: body) }
  let(:body) { 'hello' }
  let(:route_set_list) { [rails_route_set, engine_route_set] }

  let(:rails_route_set) do
    route_set = ActionDispatch::Routing::RouteSet.new.tap do |routes|
      routes.draw do
        get '/articles' => 'articles#index'
      end
    end
    JSRailsRoutes::RouteSet.new('Rails', route_set)
  end

  let(:engine_route_set) do
    route_set = ActionDispatch::Routing::RouteSet.new.tap do |routes|
      routes.draw do
        get '/users' => 'users#index'
      end
    end
    JSRailsRoutes::RouteSet.new('Users::Engine', route_set)
  end

  describe '#build' do
    subject { builder.build }

    it 'returns a hash between engine name and its content' do
      should match(rails_route_set.name => body, engine_route_set.name => body)
      expect(language).to have_received(:handle_route_set).twice
    end
  end
end
