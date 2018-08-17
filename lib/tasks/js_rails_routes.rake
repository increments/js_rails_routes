# frozen_string_literal: true

desc 'Generate a ES6 module that contains Rails routes'
namespace :js do
  task routes: :environment do |task|
    JSRailsRoutes.config.configure_with_env_vars
    JSRailsRoutes.generate(task)
    puts "Routes saved into #{JSRailsRoutes.config.output_dir}."
  end
end
