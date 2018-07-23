# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Generator do
  include_context 'run in a sandbox'

  subject(:generator) { described_class.new(builder, writable: writable) }

  let(:writable) { spy('writable') }
  let(:builder) { double('builder', build: result) }
  let(:result) { Hash['Rails' => 'rails body', 'Admin::Engine' => 'admin body'] }

  describe '#generate' do
    subject { generator.generate(task) }

    let(:task) { 'js:routes' }

    it 'writes with path to file and its contents' do
      allow(writable).to receive(:write)
      subject
      expect(writable).to have_received(:write).with(
        a_string_ending_with('app/assets/javascripts/rails-routes.js'),
        a_string_including('rails body')
      ).ordered
      expect(writable).to have_received(:write).with(
        a_string_ending_with('app/assets/javascripts/admin-routes.js'),
        a_string_including('admin body')
      ).ordered
    end
  end
end
