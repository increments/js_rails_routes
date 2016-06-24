module JSRailsRoutes
  class Generator
    COMPARE_REGEXP = /:(.*?)(\/|$)/

    def initialize(includes: nil, excludes: nil)
      @includes = includes
      @excludes = excludes
      Rails.application.reload_routes!
    end

    def generate(task, save_path)
      lines = ["// Don't edit manually. `rake #{task}#{env}` generates this file."]
      lines += routes.map do |name, path|
        handle_route(name, path) if match?(name, path)
      end.compact
      lines += '' # End with new line
      File.open(save_path, 'w') { |f| f.write(lines.join("\n")) }
    end

    private

    attr_reader :includes, :excludes

    def includes_regexp
      @includes_regexp ||= Regexp.new(includes)
    end

    def excludes_regexp
      @excludes_regexp ||= Regexp.new(excludes)
    end

    def match?(name, path)
      return false if includes && includes_regexp !~ path
      return false if excludes && excludes_regexp =~ path
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

    def env
      result = []
      result << "includes='#{includes}'" if includes
      result << "excludes='#{excludes}'" if excludes
      result.empty? ? '' : ' ' + result.join(' ')
    end
  end
end
