desc 'Generate a ES6 module that contains Rails routes'
namespace :js do
  task routes: :environment do |task|
    generator = JSRailsRoutes::Generator.instance
    generator.includes = Regexp.new(ENV['includes']) if ENV['includes']
    generator.excludes = Regexp.new(ENV['excludes']) if ENV['excludes']
    generator.path = ENV['path'] if ENV['path']
    generator.generate(task)
    puts "Routes saved to #{generator.path}."
  end
end
