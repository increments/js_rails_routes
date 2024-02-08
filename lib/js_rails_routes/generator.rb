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
      builder.build.each do |artifact|
        file_name = File.join(config.output_dir, artifact.file_name)
        file_body = <<~FILE_BODY.chomp
          /* eslint-disable */
          // Don't edit manually. `rake #{task}` generates this file.
          #{artifact.body}
        FILE_BODY
        writable.write(file_name, file_body)
      end
    end

    private

    attr_reader :writable, :builder

    # @return [JSRailsRoutes::Configuration]
    def config
      JSRailsRoutes.config
    end
  end
end
