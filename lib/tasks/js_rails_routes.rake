desc 'Generate a ES6 module that contains Rails routes'
namespace :js do
  task routes: :environment do |task|
    path =  ENV['path'] || Rails.root.join('app', 'assets', 'javascripts', 'rails-routes.js')
    generator = JSRailsRoutes::Generator.instance
    generator.includes = Regexp.new(ENV['includes']) if ENV['includes']
    generator.excludes = Regexp.new(ENV['excludes']) if ENV['excludes']
    generator.generate(task, path)
    puts "Routes saved to #{path}."
  end
end
