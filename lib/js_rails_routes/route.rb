# frozen_string_literal: true

module JSRailsRoutes
  # Encapsulate a single routing rule
  class Route
    # @return [String] route name. It becomes JavaScript function name.
    attr_accessor :name

    # @return [String]
    attr_reader :path

    # @return [ActionDispatch::Journey::Route]
    attr_reader :route

    # @param route [ActionDispatch::Journey::Route]
    def initialize(route)
      @route = route
      @name = route.name
      @path = route.path.spec.to_s.split('(').first
    end

    # @return [Boolean]
    def match? # rubocop:disable Metrics/AbcSize
      return false if config.include_paths !~ path
      return false if config.exclude_paths =~ path
      return false if config.include_names !~ name
      return false if config.exclude_names =~ name

      config.route_filter.call(self)
    end

    private

    # @return [JSRailsRoutes::Configuration]
    def config
      JSRailsRoutes.config
    end
  end
end
