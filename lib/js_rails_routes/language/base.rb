# frozen_string_literal: true

module JSRailsRoutes
  module Language
    class Base
      # @param routes [JSRailsRoutes::RouteSet]
      # @return [String]
      def handle_route_set(routes) # rubocop:disable Lint/UnusedMethodArgument
        raise NotImplementedError
      end

      private

      # @return [JSRailsRoutes::Configuration]
      def config
        JSRailsRoutes.config
      end
    end
  end
end
