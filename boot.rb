require 'rubygems'
require 'bundler/setup'

APP_ENV = ENV['APP_ENV'] || 'development'
APP_PATH = File.dirname(__FILE__)

Bundler.require(:defaut, APP_ENV.to_sym)
$LOAD_PATH.unshift File.join(APP_PATH, 'lib')

require 'nblogger'
