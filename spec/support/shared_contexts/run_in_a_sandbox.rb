# frozen_string_literal: true

RSpec.shared_context 'run in a sandbox' do # rubocop:disable RSpec/ContextWording
  around do |example|
    JSRailsRoutes.sandbox { example.run }
  end
end
