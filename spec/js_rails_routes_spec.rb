# frozen_string_literal: true

RSpec.describe JSRailsRoutes do
  describe '.configure' do
    it 'yields with Generator instance' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(JSRailsRoutes::Generator.instance)
    end
  end
end
