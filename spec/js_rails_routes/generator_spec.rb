RSpec.describe JSRailsRoutes::Generator do
  let(:generator) do
    described_class.clone.instance
  end

  it { expect(described_class).to include(Singleton) }

  describe '#generate' do
    subject do
      generator.generate(task)
    end

    let(:task) do
      'js:routes'
    end

    it 'writes a JS file' do
      expect(generator).to receive(:write).with(a_string_including("rake #{task}"))
      subject
    end

    context 'when include_paths is given' do
      before do
        generator.include_paths = include_paths
      end

      let(:include_paths) do
        %r{/new}
      end

      it 'writes paths matching with the parameter' do
        expect(generator).to receive(:write).with(a_kind_of(String)) do |arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          expect(paths).to all(match(include_paths))
        end
        subject
      end
    end

    context 'when exclude_paths is given' do
      before do
        generator.exclude_paths = exclude_paths
      end

      let(:exclude_paths) do
        %r{/new}
      end

      it 'writes paths not matching with the parameter' do
        expect(generator).to receive(:write).with(a_kind_of(String)) do |arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          paths.each do |path|
            expect(path).to_not match(exclude_paths)
          end
        end
        subject
      end
    end

    context 'when include_names is given' do
      before do
        generator.include_names = include_names
      end

      let(:include_names) do
        /user/
      end

      it 'writes paths matching with the parameter' do
        expect(generator).to receive(:write).with(a_kind_of(String)) do |arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          expect(paths).to all(match(include_names))
        end
        subject
      end
    end

    context 'when exclude_names is given' do
      before do
        generator.exclude_names = exclude_names
      end

      let(:exclude_names) do
        /user/
      end

      it 'writes paths not matching with the parameter' do
        expect(generator).to receive(:write).with(a_kind_of(String)) do |arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          paths.each do |path|
            expect(path).to_not match(exclude_names)
          end
        end
        subject
      end
    end
  end
end
