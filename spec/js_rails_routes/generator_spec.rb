RSpec.describe JSRailsRoutes::Generator do
  let(:generator) do
    described_class.clone.instance
  end

  it { expect(described_class).to include(Singleton) }

  describe '#generate' do
    let(:output_dir) { File.expand_path('spec/tmp') }
    subject do
      generator.output_dir = output_dir
      generator.generate(task)
    end

    let(:task) do
      'js:routes'
    end

    it 'writes JS files' do
      expect(generator).to receive(:write)
        .with(be_in(['Rails', 'Admin::Engine']), a_string_including("rake #{task}"))
        .twice
      subject
    end

    context 'when actually creating files' do
      let(:js_files) { Dir.glob(File.join(output_dir, '{admin,rails}-routes.js')).map { |file| Pathname.new(file) } }

      after { FileUtils.rm_f(js_files) }

      it 'creates JS files' do
        subject
        expect(js_files).to all be_file
      end
    end

    context 'when include_paths is given' do
      before do
        generator.include_paths = include_paths
      end

      let(:include_paths) do
        %r{/new}
      end

      it 'writes paths matching with the parameter' do
        expect(generator).to receive(:write)
          .with(be_in(['Rails', 'Admin::Engine']), a_kind_of(String))
          .twice do |_, arg|
            paths = arg.split("\n")[(2 + described_class::PROCESS_FUNC.split("\n").size)..-1]
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
        expect(generator).to receive(:write)
          .with(be_in(['Rails', 'Admin::Engine']), a_kind_of(String))
          .twice do |_, arg|
            paths = arg.split("\n")[(2 + described_class::PROCESS_FUNC.split("\n").size)..-1]
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
        /user|note/
      end

      it 'writes paths matching with the parameter' do
        expect(generator).to receive(:write)
          .with(be_in(['Rails', 'Admin::Engine']), a_kind_of(String))
          .twice do |_, arg|
            paths = arg.split("\n")[(2 + described_class::PROCESS_FUNC.split("\n").size)..-1]
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
        /user|note/
      end

      it 'writes paths not matching with the parameter' do
        expect(generator).to receive(:write)
          .with(be_in(['Rails', 'Admin::Engine']), a_kind_of(String))
          .twice do |_, arg|
            paths = arg.split("\n")[(2 + described_class::PROCESS_FUNC.split("\n").size)..-1]
            expect(paths).not_to be_empty
            paths.each do |path|
              expect(path).to_not match(exclude_names)
            end
          end
        subject
      end
    end

    context 'when exclude_engines is given' do
      before do
        generator.exclude_engines = exclude_engines
      end

      let(:exclude_engines) do
        /^admin/
      end

      let(:excluded_routes) do
        /note|photo/
      end

      it 'writes paths not matching with the parameter' do
        expect(generator).to receive(:write)
          .with(be_in(['Rails', 'Admin::Engine']), a_kind_of(String))
          .once do |_, arg|
            paths = arg.split("\n")[(2 + described_class::PROCESS_FUNC.split("\n").size)..-1]
            expect(paths).not_to be_empty
            paths.each do |path|
              expect(path).to_not match(excluded_routes)
            end
          end
        subject
      end
    end
  end
end
