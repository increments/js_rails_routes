# frozen_string_literal: true

RSpec.describe JSRailsRoutes::Configuration do
  subject(:config) { described_class.new }

  describe '#configure_with_env_vars' do
    subject { config.configure_with_env_vars(env) }

    context 'with empty env' do
      let(:env) { Hash[] }

      it 'does not change' do
        expect { subject }.to not_change(config, :include_paths)
                         .and not_change(config, :exclude_paths)
                         .and not_change(config, :include_names)
                         .and not_change(config, :exclude_names)
                         .and not_change(config, :exclude_engines)
                         .and not_change(config, :output_dir)
                         .and not_change(config, :camelize)
      end
    end

    context 'with include_paths env' do
      let(:env) { Hash['include_paths' => 'a'] }

      it 'changes #include_paths' do
        expect { subject }.to change(config, :include_paths).to eq(/a/)
      end
    end

    context 'with exclude_paths env' do
      let(:env) { Hash['exclude_paths' => 'a'] }

      it 'changes #exclude_paths' do
        expect { subject }.to change(config, :exclude_paths).to eq(/a/)
      end
    end

    context 'with include_names env' do
      let(:env) { Hash['include_names' => 'a'] }

      it 'changes #include_names' do
        expect { subject }.to change(config, :include_names).to eq(/a/)
      end
    end

    context 'with exclude_names env' do
      let(:env) { Hash['exclude_names' => 'a'] }

      it 'changes #exclude_names' do
        expect { subject }.to change(config, :exclude_names).to eq(/a/)
      end
    end

    context 'with exclude_engines env' do
      let(:env) { Hash['exclude_engines' => 'a'] }

      it 'changes #exclude_engines' do
        expect { subject }.to change(config, :exclude_engines).to eq(/a/)
      end
    end

    context 'with output_dir env' do
      let(:env) { Hash['output_dir' => 'path'] }

      it 'changes #output_dir' do
        expect { subject }.to change(config, :output_dir).to eq 'path'
      end
    end

    context 'with camelize env' do
      let(:env) { Hash['camelize' => 'lower'] }

      it 'changes #camelize' do
        expect { subject }.to change(config, :camelize).to eq :lower
      end
    end
  end
end
