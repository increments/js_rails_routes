# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Generator do
  subject(:generator) { described_class.new(builder, writable: writable) }

  include_context 'run in a sandbox'

  let(:writable) { spy('writable') }
  let(:builder) { double('builder', build: result) }
  let(:result) do
    [
      JSRailsRoutes::Builder::Artifact.new('Rails', 'js', 'rails body'),
      JSRailsRoutes::Builder::Artifact.new('Admin::Engine', 'js', 'admin body')
    ]
  end

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
