require 'rubygems'
require 'bundler/setup'
require 'logger'

APP_ENV = ENV['APP_ENV'] || 'development'
APP_PATH = File.dirname(__FILE__)
LOG_LEVEL = (ENV['LOG_LEVEL'] || '0').to_i
LOGGER = Logger.new('log/nano-blog.log')
LOGGER.level = LOG_LEVEL

Bundler.require(:defaut, APP_ENV.to_sym)
$LOAD_PATH.unshift File.join(APP_PATH, 'lib')

require 'nblogger'
