# frozen_string_literal: true

module JSRailsRoutes
  class Configuration
    attr_accessor :include_paths,
                  :exclude_paths,
                  :include_names,
                  :exclude_names,
                  :exclude_engines,
                  :output_dir,
                  :camelize

    def initialize
      self.include_paths = /.*/
      self.exclude_paths = /^$/
      self.include_names = /.*/
      self.exclude_names = /^$/
      self.exclude_engines = /^$/
      self.camelize = nil
      self.output_dir = Rails.root.join('app', 'assets', 'javascripts')
    end

    def configure_with_env_vars # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
      self.include_paths = Regexp.new(ENV['include_paths']) if ENV['include_paths']
      self.exclude_paths = Regexp.new(ENV['exclude_paths']) if ENV['exclude_paths']
      self.include_names = Regexp.new(ENV['include_names']) if ENV['include_names']
      self.exclude_names = Regexp.new(ENV['exclude_names']) if ENV['exclude_names']
      self.output_dir = ENV['output_dir'] if ENV['output_dir']
      self.camelize = ENV['camelize']&.to_sym if ENV['camelize']
    end
  end
end
