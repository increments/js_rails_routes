# frozen_string_literal: true

require 'js_rails_routes/route_set'

module JSRailsRoutes
  class Builder
    Artifact = Struct.new(:engine_name, :ext, :body) do
      # @return [String]
      def file_name
        "#{engine_name.gsub('::Engine', '').underscore.tr('/', '-')}-routes.#{ext}"
      end
    end

    # @return [Array<JSRailsRoutes::RouteSet>]
    attr_reader :route_set_list

    # @return [JSRailsRoutes::Language::Base]
    attr_reader :language

    # @param language [JSRailsRoutes::Language::Base]
    # @param route_set_list [Array<JSRailsRoutes::RouteSet>]
    def initialize(language, route_set_list = RouteSet.correct_matching_route_set_list)
      @language = language
      @route_set_list = route_set_list
    end

    # @return [Array<Artifact>]
    def build
      route_set_list.map do |route_set|
        Artifact.new(route_set.name, language.ext, language.handle_route_set(route_set))
      end
    end
  end
end
