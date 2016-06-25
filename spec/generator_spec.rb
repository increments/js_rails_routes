RSpec.describe JSRailsRoutes::Generator do
  let(:generator) do
    described_class.new(params)
  end

  let(:params) do
    {}
  end

  describe '#generate' do
    subject do
      generator.generate(task, save_path)
    end

    let(:task) do
      'js:routes'
    end

    let(:save_path) do
      'app/assets/javascripts/rails-routes.js'
    end

    it 'writes a JS file' do
      expect(generator).to receive(:write).with(save_path, a_string_including("rake #{task}"))
      subject
    end

    context 'when includes parameter is given' do
      before do
        params[:includes] = Regexp.new(includes)
      end

      let(:includes) do
        '/new'
      end

      it 'writes paths matching with the parameter' do
        expect(generator).to receive(:write).with(save_path, a_kind_of(String)) do |_, arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          expect(paths).to all(a_string_including(includes))
        end
        subject
      end
    end

    context 'when excludes parameter is given' do
      before do
        params[:excludes] = Regexp.new(excludes)
      end

      let(:excludes) do
        '/new'
      end

      it 'writes paths not matching with the parameter' do
        expect(generator).to receive(:write).with(save_path, a_kind_of(String)) do |_, arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          paths.each do |path|
            expect(path).to_not include(excludes)
          end
        end
        subject
      end
    end
  end
end
