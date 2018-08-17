# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Language::TypeScript do
  subject(:language) { described_class.new }

  include_context 'run in a sandbox'

  describe '::PROCESS_FUNC' do
    subject { described_class::PROCESS_FUNC }

    it 'returns a typescript function' do
      is_expected.to eq <<~TYPESCRIPT
        type Params = Record<string, string | number>
        function process(route: string, params: Params, keys: string[]): string {
          var query = [];
          for (var param in params) if (params.hasOwnProperty(param)) {
            if (keys.indexOf(param) === -1) {
              query.push(param + "=" + encodeURIComponent(params[param].toString()));
            }
          }
          return query.length ? route + "?" + query.join("&") : route;
        }
      TYPESCRIPT
    end
  end

  describe '#handle_route_set' do
    subject { language.handle_route_set(route_set) }

    let(:route_set) do
      rails_route_set = ActionDispatch::Routing::RouteSet.new.tap do |routes|
        routes.draw do
          resources :articles
        end
      end
      JSRailsRoutes::RouteSet.new('Rails', rails_route_set)
    end

    context 'without camelize option' do
      it 'returns a typescript with snake_case functions' do
        is_expected.to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articles_path(params: Params) { return process('/articles', params, []); }
          export function new_article_path(params: Params) { return process('/articles/new', params, []); }
          export function edit_article_path(params: Params) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function article_path(params: Params) { return process('/articles/' + params.id + '', params, ['id']); }
        TYPESCRIPT
      end
    end

    context 'with camelize = :lower option' do
      before do
        JSRailsRoutes.configure do |c|
          c.camelize = :lower
        end
      end

      it 'returns a javascript with lowerCamelCase functions' do
        is_expected.to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articlesPath(params: Params) { return process('/articles', params, []); }
          export function newArticlePath(params: Params) { return process('/articles/new', params, []); }
          export function editArticlePath(params: Params) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function articlePath(params: Params) { return process('/articles/' + params.id + '', params, ['id']); }
        TYPESCRIPT
      end
    end

    context 'with camelize = :upper option' do
      before do
        JSRailsRoutes.configure do |c|
          c.camelize = :upper
        end
      end

      it 'returns a javascript with UpperCamelCase functions' do
        is_expected.to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function ArticlesPath(params: Params) { return process('/articles', params, []); }
          export function NewArticlePath(params: Params) { return process('/articles/new', params, []); }
          export function EditArticlePath(params: Params) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function ArticlePath(params: Params) { return process('/articles/' + params.id + '', params, ['id']); }
        TYPESCRIPT
      end
    end

    context 'with include_paths option' do
      before do
        JSRailsRoutes.configure do |c|
          c.include_paths = /new/
        end
      end

      it 'returns a javascript matching to the regexp' do
        is_expected.to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function new_article_path(params: Params) { return process('/articles/new', params, []); }
        TYPESCRIPT
      end
    end

    context 'with exclude_paths option' do
      before do
        JSRailsRoutes.configure do |c|
          c.exclude_paths = /new/
        end
      end

      it 'returns a javascript not matching to the regexp' do
        is_expected.to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articles_path(params: Params) { return process('/articles', params, []); }
          export function edit_article_path(params: Params) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function article_path(params: Params) { return process('/articles/' + params.id + '', params, ['id']); }
        TYPESCRIPT
      end
    end

    context 'with include_names option' do
      before do
        JSRailsRoutes.configure do |c|
          c.include_names = /new/
        end
      end

      it 'returns a javascript matching to the regexp' do
        is_expected.to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function new_article_path(params: Params) { return process('/articles/new', params, []); }
        TYPESCRIPT
      end
    end

    context 'with exclude_names option' do
      before do
        JSRailsRoutes.configure do |c|
          c.exclude_names = /new/
        end
      end

      it 'returns a javascript not matching to the regexp' do
        is_expected.to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articles_path(params: Params) { return process('/articles', params, []); }
          export function edit_article_path(params: Params) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function article_path(params: Params) { return process('/articles/' + params.id + '', params, ['id']); }
        TYPESCRIPT
      end
    end
  end

  describe '#ext' do
    subject { language.ext }

    it { is_expected.to eq 'ts' }
  end
end
