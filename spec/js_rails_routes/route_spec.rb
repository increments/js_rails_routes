# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Route do
  subject(:route) { described_class.new(raw_route) }

  include_context 'run in a sandbox'

  let(:raw_route) do
    ActionDispatch::Routing::RouteSet.new.tap do |routes|
      routes.draw do
        get '/articles' => 'articles#index'
      end
    end.routes.first
  end

  describe '#name' do
    subject { route.name }

    it { is_expected.to eq 'articles' }
  end

  describe '#name=' do
    subject { route.name = value }

    let(:value) { 'foo' }

    it { expect { subject }.to change(route, :name).to(value) }
  end

  describe '#path' do
    subject { route.path }

    it { is_expected.to eq '/articles' }
  end

  describe '#match?' do
    subject { route.match? }

    it { is_expected.to be true }

    context 'when include_paths option is specified' do
      before do
        JSRailsRoutes.configure do |c|
          c.include_paths = include_paths
        end
      end

      context 'and it matches to the path' do
        let(:include_paths) { /articles/ }

        it { is_expected.to be true }
      end

      context 'and it does not matche to the path' do
        let(:include_paths) { /users/ }

        it { is_expected.to be false }
      end
    end

    context 'when exclude_paths option is specified' do
      before do
        JSRailsRoutes.configure do |c|
          c.exclude_paths = exclude_paths
        end
      end

      context 'and it matches to the path' do
        let(:exclude_paths) { /articles/ }

        it { is_expected.to be false }
      end

      context 'and it does not matche to the path' do
        let(:exclude_paths) { /users/ }

        it { is_expected.to be true }
      end
    end

    context 'when include_names option is specified' do
      before do
        JSRailsRoutes.configure do |c|
          c.include_names = include_names
        end
      end

      context 'and it matches to the name' do
        let(:include_names) { /articles/ }

        it { is_expected.to be true }
      end

      context 'and it does not matche to the name' do
        let(:include_names) { /users/ }

        it { is_expected.to be false }
      end
    end

    context 'when exclude_names option is specified' do
      before do
        JSRailsRoutes.configure do |c|
          c.exclude_names = exclude_names
        end
      end

      context 'and it matches to the name' do
        let(:exclude_names) { /articles/ }

        it { is_expected.to be false }
      end

      context 'and it does not matche to the name' do
        let(:exclude_names) { /users/ }

        it { is_expected.to be true }
      end
    end

    context 'when route_filter option is specified' do
      before do
        JSRailsRoutes.configure do |c|
          c.route_filter = ->(_route) { result }
        end
      end

      context 'and it returns true' do
        let(:result) { true }

        it { is_expected.to be true }
      end

      context 'and it returns false' do
        let(:result) { false }

        it { is_expected.to be false }
      end
    end
  end
end
