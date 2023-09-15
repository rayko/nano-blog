# coding: utf-8
# Core
require 'rubygems'
require 'bundler/setup'
require 'logger'
require 'digest'
require 'json'
require 'base64'

APP_ENV = ENV['APP_ENV'] || 'development'
APP_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift File.join(APP_PATH, 'lib')
$LOAD_PATH.unshift File.join(APP_PATH)

require 'extensions/blank'
require 'configs'

Object.include(Extensions::Blank)

# Bundler.setup(:default, APP_ENV.to_sym)
Bundler.require(:default)
Bundler.require(:development) if APP_ENV == 'development'
Bundler.require(:test) if APP_ENV == 'test'

if APP_ENV == 'development'
  Dotenv.load ".env.local"
end

# Some defs
CONFIG = Configs.new
LOGGER = Logger.new('log/nano-blog.log')
LOGGER.level = CONFIG.log_level
DB_FILE = File.join('db', ['nanoBlog', APP_ENV, 'db'].join('.'))

# App core
require 'sqlite3'
require 'sequel'
require 'bcrypt'

# Lib stuff
require 'init_procedure'
require 'json_payload'
require 'auth'
require 'auth_middleware'

# Models if DB exists
if File.exist? DB_FILE
  Sequel.sqlite(DB_FILE)

  require 'models/log_entry'
  require 'models/component'
  require 'models/log_entry_template'
  require 'models/user'
  require 'models/token'
end

# Controllers ¿?
require 'website'
require 'api/components'
require 'api/log_entries'
require 'api/log_entry_templates'
require 'api/authenticate'

