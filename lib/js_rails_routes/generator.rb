require 'singleton'

module JSRailsRoutes
  class Generator
    COMPARE_REGEXP = /:(.*?)(\/|$)/

    include Singleton

    attr_accessor :includes, :excludes

    def initialize
      Rails.application.reload_routes!
    end

    def generate(task, save_path)
      lines = ["// Don't edit manually. `rake #{task}` generates this file."]
      lines += routes.map do |name, path|
        handle_route(name, path) if match?(name, path)
      end.compact
      lines += [''] # End with new line
      write(save_path, lines.join("\n"))
    end

    private

    def match?(name, path)
      return false if includes && includes !~ path
      return false if excludes && excludes =~ path
      true
    end

    def handle_route(name, path)
      path.sub!(COMPARE_REGEXP, "' + params.#{$1} + '#{$2}") while path =~ COMPARE_REGEXP
      "export function #{name}_path(params) { return '#{path}'; }"
    end

    def routes
      @routes ||= Rails.application.routes.routes
        .select(&:name)
        .map { |r| [r.name, r.path.spec.to_s.split('(')[0]] }
        .sort { |a, b| a[0] <=> b[0] }
    end

    def write(save_path, string)
      File.open(save_path, 'w') { |f| f.write(string) }
    end
  end
end
