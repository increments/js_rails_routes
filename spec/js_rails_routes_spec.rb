# frozen_string_literal: true

RSpec.describe JSRailsRoutes do
  describe '.configure' do
    it 'yields with .config' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(described_class.config)
    end
  end

  describe '.config' do
    subject { described_class.config }

    it { is_expected.to be_a JSRailsRoutes::Configuration }
  end

  describe '.sandbox' do
    it 'yields within a new sandbox' do
      original = described_class.config
      described_class.sandbox do
        expect(described_class.config).not_to be original
        expect(described_class.config).to be_a JSRailsRoutes::Configuration
      end
      expect(described_class.config).to be original
    end
  end

  describe '.generate_javascript' do
    subject { described_class.generate_javascript(task) }

    let(:task) { 'js:routes' }
    let(:app_root) { JSRailsRoutes::SpecHelper::TestApp.root }

    before do
      FileUtils.rm_rf(app_root)
      FileUtils.mkdir_p(app_root.join('app/assets/javascripts'))
    end

    it 'generates javascript files' do
      subject

      expect(File.read(app_root.join('app/assets/javascripts/rails-routes.js'))).to eq <<~JAVASCRIPT
        // Don't edit manually. `rake #{task}` generates this file.
        #{JSRailsRoutes::Language::JavaScript::PROCESS_FUNC}
        export function blogs_path(params) { return process('/blogs', params, []); }
        export function new_blog_path(params) { return process('/blogs/new', params, []); }
        export function edit_blog_path(params) { return process('/blogs/' + params.id + '/edit', params, ['id']); }
        export function blog_path(params) { return process('/blogs/' + params.id + '', params, ['id']); }
        export function users_path(params) { return process('/users', params, []); }
        export function new_user_path(params) { return process('/users/new', params, []); }
        export function edit_user_path(params) { return process('/users/' + params.id + '/edit', params, ['id']); }
        export function user_path(params) { return process('/users/' + params.id + '', params, ['id']); }
      JAVASCRIPT

      expect(File.read(app_root.join('app/assets/javascripts/admin-routes.js'))).to eq <<~JAVASCRIPT
        // Don't edit manually. `rake #{task}` generates this file.
        #{JSRailsRoutes::Language::JavaScript::PROCESS_FUNC}
        export function notes_path(params) { return process('/notes', params, []); }
        export function new_note_path(params) { return process('/notes/new', params, []); }
        export function edit_note_path(params) { return process('/notes/' + params.id + '/edit', params, ['id']); }
        export function note_path(params) { return process('/notes/' + params.id + '', params, ['id']); }
        export function photos_path(params) { return process('/photos', params, []); }
        export function new_photo_path(params) { return process('/photos/new', params, []); }
        export function edit_photo_path(params) { return process('/photos/' + params.id + '/edit', params, ['id']); }
        export function photo_path(params) { return process('/photos/' + params.id + '', params, ['id']); }
      JAVASCRIPT
    end
  end
end
