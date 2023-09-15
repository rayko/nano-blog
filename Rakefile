task default: :console



desc 'Loads the environment for the application'
task :environment do
  require File.join(File.dirname(__FILE__), 'boot')
end

namespace :db do
  desc 'Setups database if not existent and loads initial data'
  task setup: :environment do
    puts 'Setting up database ... '
    require 'schema'
    Schema.new.setup!
    puts 'Database Ready!'
  end
end

desc 'Writes some log entries on boot'
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

desc 'Creates an emergency token for external access'
task emergency_token: :environment do
  token = Token.generate!
  puts token.value
  puts "Valid until: #{Time.at(token.expires_at)}"
end

namespace :users do
  desc 'Creates a user, use as rake users:create <username> <password>'
  task create: :environment do
    if ARGV[1].blank?
      puts 'Missing username'
      exit 1
    end

    if ARGV[2].blank?
      puts 'Missing password'
      exit 1
    end

    user = User.new
    user.username = ARGV[1].strip
    user.set_password(ARGV[2].strip)

    if User.where(username: user.username).first
      puts 'Already exists'
      exit 1
    end

    user.save
    
    puts "Created new user: #{user.username}"
    exit 0
  end

  desc 'Removes a user, use as rake users:remove <username>'
  task remove: :environment do
    if ARGV[1].blank?
      puts 'Missing username'
      exit 1
    end

    user = User.where(username: ARGV[1].strip).first
    unless user
      puts 'Not found'
      exit 1
    end

    user.destroy
    puts "User: #{user.username} removed!"
    exit 0
  end
end
