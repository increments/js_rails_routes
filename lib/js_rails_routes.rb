# frozen_string_literal: true

require 'js_rails_routes/engine'
require 'js_rails_routes/configuration'
require 'js_rails_routes/generator'
require 'js_rails_routes/version'
require 'js_rails_routes/language/javascript'
require 'js_rails_routes/language/typescript'

module JSRailsRoutes
  PARAM_REGEXP = %r{:(.*?)(/|$)}

  module_function

  # @yield [Configuration]
  def configure
    yield config if block_given?
  end

  # Current configuration.
  #
  # @return [Configuration]
  def config
    @config ||= Configuration.new
  end

  # @param task [String]
  def generate(task)
    builder = Builder.new(JSRailsRoutes.language)
    Generator.new(builder).generate(task)
  end

  # Execute a given block within a new sandbox. For test purpose.
  #
  # @yield
  def sandbox
    raise 'Already in a sandbox' if @sandbox

    @sandbox = true
    prev = @config
    @config = Configuration.new
    begin
      yield if block_given?
    ensure
      @config = prev
      @sandbox = nil
    end
  end

  # @return [JSRailsRoutes::Language::Base]
  def language
    case config.target
    when 'js'
      Language::JavaScript.new
    when 'ts'
      Language::TypeScript.new
    else
      raise NotImplementedError, config.target
    end
  end
end
