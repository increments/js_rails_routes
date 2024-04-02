# frozen_string_literal: true

require 'js_rails_routes/route'
require 'js_rails_routes/language/javascript'

module JSRailsRoutes
  module Language
    class TypeScript < JavaScript
      PROCESS_FUNC = <<~TYPESCRIPT
        type Value = string | number | Value[]
        type Params<Keys extends string> = { [key in Keys]: Value } & Record<string, Value>
        function process(route: string, params: Record<string, Value> | undefined, keys: string[]): string {
          if (!params) return route
          var query: string[] = [];
          for (var param in params) if (Object.prototype.hasOwnProperty.call(params, param)) {
            if (keys.indexOf(param) === -1) {
              if (Array.isArray(params[param])) {
                for (var value of params[param] as Value[]) {
                  query.push(param + "[]=" + encodeURIComponent(value.toString()));
                }
              } else {
                query.push(param + "=" + encodeURIComponent(params[param].toString()));
              }
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
        params = keys.empty? ? 'params?: Record<string, Value>' : "params: Params<#{keys.join(' | ')}>"
        "export function #{name}(#{params}) { return process('#{path}', params, [#{keys.join(',')}]); }"
      end

      # @note Implementation for {JSRailsRoutes::Language::Base#ext}
      def ext
        'ts'
      end
    end
  end
end
