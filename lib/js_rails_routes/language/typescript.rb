# frozen_string_literal: true

require 'js_rails_routes/route'
require 'js_rails_routes/language/javascript'

module JSRailsRoutes
  module Language
    class TypeScript < JavaScript
      PROCESS_FUNC = <<~TYPESCRIPT
        type Params = Record<string, string | number>
        function process(route: string, params: Params, keys: string[]): string {
          var query = [];
          for (var param in params) if (params.hasOwnProperty(param)) {
            if (keys.indexOf(param) === -1) {
              query.push(param + "=" + encodeURIComponent(params[param].toString()));
            }
          }
          return query.length ? route + "?" + query.join("&") : route;
        }
      TYPESCRIPT

      # @param route [JSRailsRoutes::Route]
      # @return [String]
      def handle_route(route)
        path, keys = parse(route.path)
        name = function_name(route.name)
        "export function #{name}(params: Params) { return process('#{path}', params, [#{keys.join(',')}]); }"
      end

      # @note Implementation for {JSRailsRoutes::Language::Base#ext}
      def ext
        'ts'
      end
    end
  end
end
