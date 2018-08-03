# frozen_string_literal: true

RSpec.describe JSRailsRoutes::RouteSet do
  subject(:route_set) { described_class.new(name, routes) }

  include_context 'run in a sandbox'

  let(:name) { 'Foo::Engine' }
  let(:routes) do
    ActionDispatch::Routing::RouteSet.new.tap do |routes|
      routes.draw do
        get '/articles' => 'articles#index'
        get '/users' => 'users#index'
      end
    end
  end

  describe '.correct_matching_route_set_list' do
    subject { described_class.correct_matching_route_set_list }

    it 'returns an array of matching route sets' do
      # See spec/support/test_app.rb
      is_expected.to match [
        be_a(described_class).and(have_attributes(name: 'Rails')).and(be_match),
        be_a(described_class).and(have_attributes(name: 'Admin::Engine')).and(be_match)
      ]
    end
  end

  describe '#name' do
    subject { route_set.name }

    it { is_expected.to eq name }
  end

  describe '#routes' do
    subject { route_set.routes }

    it { is_expected.to all be_a(JSRailsRoutes::Route).and(be_match) }

    context 'when some routes are excluded' do
      before do
        JSRailsRoutes.configure do |c|
          c.exclude_names = /users/
        end
      end

      it "doesn't include the excluded route" do
        is_expected.to include be_a(JSRailsRoutes::Route).and(have_attributes(name: /articles/))
        is_expected.not_to include be_a(JSRailsRoutes::Route).and(have_attributes(name: /users/))
      end
    end
  end

  describe '#match?' do
    subject { route_set.match? }

    it { is_expected.to be true }

    context 'when exclude_engines option is specified' do
      before do
        JSRailsRoutes.configure do |c|
          c.exclude_engines = exclude_engines
        end
      end

      context 'and it matches to the name' do
        let(:exclude_engines) { /Foo/ }

        it { is_expected.to be false }
      end

      context 'and it does not match to the name' do
        let(:exclude_engines) { /Bar/ }

        it { is_expected.to be true }
      end

      context 'and it does not match to the name in a case-sensitive manner' do
        let(:exclude_engines) { /foo/ }

        it { is_expected.to be false }
      end
    end

    context 'when routes are empty' do
      before { allow(route_set).to receive(:routes).and_return([]) }

      it { is_expected.to be false }
    end
  end
end
