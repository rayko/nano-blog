task default: :console

desc 'Loads the environment for the application'
task :environment do
  require File.join(File.dirname(__FILE__), 'boot')
end

desc 'Opens a console to interact with the application'
task console: :environment do
  require 'irb'
  require 'irb/completion'

  puts 'nanoBlog Console'
  ARGV.clear
  IRB.start
end
