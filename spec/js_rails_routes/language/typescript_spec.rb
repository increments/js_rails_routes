# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Language::TypeScript do
  subject(:language) { described_class.new }

  include_context 'run in a sandbox'

  describe '::PROCESS_FUNC' do
    subject { described_class::PROCESS_FUNC }

    it 'returns a typescript function' do
      expect(subject).to eq <<~TYPESCRIPT
        type Value = string | number
        type Params<Keys extends string> = { [key in Keys]: Value } & Record<string, Value>
        function process(route: string, params: Record<string, Value> | undefined, keys: string[]): string {
          if (!params) return route
          var query: string[] = [];
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
        expect(subject).to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articles_path(params?: Record<string, Value>) { return process('/articles', params, []); }
          export function new_article_path(params?: Record<string, Value>) { return process('/articles/new', params, []); }
          export function edit_article_path(params: Params<'id'>) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function article_path(params: Params<'id'>) { return process('/articles/' + params.id + '', params, ['id']); }
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
        expect(subject).to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articlesPath(params?: Record<string, Value>) { return process('/articles', params, []); }
          export function newArticlePath(params?: Record<string, Value>) { return process('/articles/new', params, []); }
          export function editArticlePath(params: Params<'id'>) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function articlePath(params: Params<'id'>) { return process('/articles/' + params.id + '', params, ['id']); }
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
        expect(subject).to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function ArticlesPath(params?: Record<string, Value>) { return process('/articles', params, []); }
          export function NewArticlePath(params?: Record<string, Value>) { return process('/articles/new', params, []); }
          export function EditArticlePath(params: Params<'Id'>) { return process('/articles/' + params.Id + '/edit', params, ['Id']); }
          export function ArticlePath(params: Params<'Id'>) { return process('/articles/' + params.Id + '', params, ['Id']); }
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
        expect(subject).to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function new_article_path(params?: Record<string, Value>) { return process('/articles/new', params, []); }
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
        expect(subject).to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articles_path(params?: Record<string, Value>) { return process('/articles', params, []); }
          export function edit_article_path(params: Params<'id'>) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function article_path(params: Params<'id'>) { return process('/articles/' + params.id + '', params, ['id']); }
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
        expect(subject).to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function new_article_path(params?: Record<string, Value>) { return process('/articles/new', params, []); }
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
        expect(subject).to eq <<~TYPESCRIPT
          #{described_class::PROCESS_FUNC}
          export function articles_path(params?: Record<string, Value>) { return process('/articles', params, []); }
          export function edit_article_path(params: Params<'id'>) { return process('/articles/' + params.id + '/edit', params, ['id']); }
          export function article_path(params: Params<'id'>) { return process('/articles/' + params.id + '', params, ['id']); }
        TYPESCRIPT
      end
    end
  end

  describe '#ext' do
    subject { language.ext }

    it { is_expected.to eq 'ts' }
  end
end
