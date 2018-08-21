# frozen_string_literal: true

module JSRailsRoutes
  class Configuration
    attr_accessor :include_paths,
                  :exclude_paths,
                  :include_names,
                  :exclude_names,
                  :exclude_engines,
                  :output_dir,
                  :camelize,
                  :target,
                  :route_filter,
                  :route_set_filter

    def initialize
      self.include_paths = /.*/
      self.exclude_paths = /^$/
      self.include_names = /.*/
      self.exclude_names = /^$/
      self.exclude_engines = /^$/
      self.camelize = nil
      self.output_dir = Rails.root.join('app', 'assets', 'javascripts')
      self.target = 'js'
      self.route_filter = ->(_route) { true }
      self.route_set_filter = ->(_route_set) { true }
    end

    # @param env [Hash{String=>String}]
    def configure_with_env_vars(env = ENV)
      %w[include_paths exclude_paths include_names exclude_names exclude_engines].each do |name|
        public_send("#{name}=", Regexp.new(env[name])) if env[name]
      end
      self.output_dir = env['output_dir'] if env['output_dir']
      self.camelize = env['camelize'].presence.to_sym if env['camelize']
      self.target = env['target'] if env['target']
    end
  end
end
