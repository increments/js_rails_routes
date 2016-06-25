require 'js_rails_routes/engine'
require 'js_rails_routes/generator'
require 'js_rails_routes/version'

module JSRailsRoutes
  module_function

  def configure
    yield Generator.instance if block_given?
  end
end
