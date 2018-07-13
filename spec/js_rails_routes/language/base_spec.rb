# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Language::Base do
  subject(:language) { described_class.new }

  describe '#handle_route_set' do
    subject { language.handle_route_set(double('route set')) }
    it { expect { subject }.to raise_error(NotImplementedError) }
  end
end
