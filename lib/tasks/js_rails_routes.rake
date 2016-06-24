desc 'Generate a ES6 module that contains Rails routes'
namespace :js do
  namespace :rails do
    task routes: :environment do |task|
      path =  ENV['path'] || Rails.root.join('app', 'assets', 'javascripts', 'rails-routes.js')
      generator = JSRailsRoutes::Generator.new(
        includes: ENV['includes'],
        excludes: ENV['excludes']
      )
      generator.generate(task, path)
      puts "Routes saved to #{path}."
    end
  end
end
