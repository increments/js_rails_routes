# frozen_string_literal: true

require 'js_rails_routes/route'
require 'js_rails_routes/language/base'

module JSRailsRoutes
  module Language
    class JavaScript < Base
      PROCESS_FUNC = <<~JAVASCRIPT
        function process(route, params, keys) {
          var query = [];
          for (var param in params) if (params.hasOwnProperty(param)) {
            if (keys.indexOf(param) === -1) {
              query.push(param + "=" + encodeURIComponent(params[param]));
            }
          }
          return query.length ? route + "?" + query.join("&") : route;
        }
      JAVASCRIPT

      # @note Implementation for {JSRailsRoutes::Language::Base#generate}
      def handle_route_set(routes)
        set = routes.each_with_object([self.class::PROCESS_FUNC]) do |route, lines|
          lines.push(handle_route(route))
        end.join("\n")
        "#{set}\n"
      end

      # @param route [JSRailsRoutes::Route]
      # @return [String]
      def handle_route(route)
        path, keys = parse(route.path)
        name = function_name(route.name)
        "export function #{name}(params) { return process('#{path}', params, [#{keys.join(',')}]); }"
      end

      # @note Implementation for {JSRailsRoutes::Language::Base#ext}
      def ext
        'js'
      end

      private

      # @param route_path [String]
      # @return [Array<(String, Array<String>)>]
      def parse(route_path)
        destructured_path = route_path.dup
        keys = []
        while destructured_path =~ JSRailsRoutes::PARAM_REGEXP
          key = camelize(Regexp.last_match(1))
          keys.push("'#{key}'")
          destructured_path.sub!(JSRailsRoutes::PARAM_REGEXP, "' + params.#{key} + '#{Regexp.last_match(2)}")
        end
        [destructured_path, keys]
      end

      # @param route_name [String]
      # @return [String]
      def function_name(route_name)
        url_helper_name = "#{route_name}_path"
        config.camelize.nil? ? url_helper_name : url_helper_name.camelize(config.camelize)
      end

      # @param name [String]
      # @return [String]
      def camelize(name)
        config.camelize ? name.camelize(config.camelize) : name
      end

      # @return [JSRailsRoutes::Configuration]
      def config
        JSRailsRoutes.config
      end
    end
  end
end
