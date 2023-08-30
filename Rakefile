task default: :console



desc 'Loads the environment for the application'
task :environment do
  require File.join(File.dirname(__FILE__), 'boot')
end

desc 'Setups database if not existent and loads initial data'
task :load_schema do
  puts 'Setting up database ... '

  require 'sqlite3'
  require 'sequel'
  load 'schema.rb'

  Schema.new.setup!

  puts 'Database Ready!'
end

task run_init: :environment do
  InitProcedure.new.run!
end

desc 'Opens a console to interact with the application'
task console: :environment do
  require 'irb'
  require 'irb/completion'

  puts 'nanoBlog Console'
  ARGV.clear
  IRB.start
end
