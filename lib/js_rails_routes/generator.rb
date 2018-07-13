# frozen_string_literal: true

require 'js_rails_routes/route_set'
require 'js_rails_routes/builder'

module JSRailsRoutes
  class Generator
    # @param builder [JSRailsRoutes::Builder]
    # @param writable [#write]
    def initialize(builder, writable: File)
      @builder = builder
      @writable = writable
    end

    # @param task [String]
    # @return [Hash{String => String}]
    def generate(task)
      builder.build.each do |name, body|
        file_name = File.join(config.output_dir, "#{convert(name)}-routes.js")
        file_body = "// Don't edit manually. `rake #{task}` generates this file.\n#{body}"
        writable.write(file_name, file_body)
      end
    end

    private

    attr_reader :writable, :builder

    # @return [JSRailsRoutes::Configuration]
    def config
      JSRailsRoutes.config
    end

    # @param engine_name [String]
    # @return [String]
    def convert(engine_name)
      engine_name.gsub('::Engine', '').underscore.tr('/', '-')
    end
  end
end
