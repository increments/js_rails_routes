require 'js_rails_routes/engine'
require 'js_rails_routes/generator'
require 'js_rails_routes/version'

module JSRailsRoutes
  module_function

  def configure(&block)
    block.call(Generator.instance)
  end
end
