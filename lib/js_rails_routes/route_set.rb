# frozen_string_literal: true

require 'js_rails_routes/route'

module JSRailsRoutes
  # Encapsulate a set of routes
  class RouteSet
    include ::Enumerable

    # @return [Array<JSRailsRoutes::RouteSet>]
    def self.correct_matching_route_set_list
      [
        RouteSet.new('Rails', ::Rails.application.routes),
        ::Rails::Engine.subclasses.map do |engine|
          RouteSet.new(engine.name, engine.routes)
        end
      ].flatten.select(&:match?)
    end

    # @!method each
    #  @yield [JSRailsRoutes::Route>]
    #  @note Implementation for {Enumerable}
    delegate :each, to: :routes

    # @return [String]
    attr_reader :name

    # @return [Array<JSRailsRoutes::Route>]
    attr_reader :routes

    # @param name [String] engine name
    # @param routes [ActionDispatch::Routing::RouteSet]
    def initialize(name, routes)
      @name = name
      @routes = routes.routes
                      .select(&:name)
                      .map { |route| Route.new(route) }
                      .select(&:match?)
    end

    # @return [Boolean]
    def match?
      return false if routes.blank?

      name !~ Regexp.new(config.exclude_engines.source, Regexp::IGNORECASE)
    end

    private

    # @return [JSRailsRoutes::Configuration]
    def config
      JSRailsRoutes.config
    end
  end
end
