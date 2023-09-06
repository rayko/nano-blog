# coding: utf-8
# Core
require 'rubygems'
require 'bundler/setup'
require 'logger'
require 'digest'
require 'json'

# Some defs
APP_ENV = ENV['APP_ENV'] || 'development'
APP_PATH = File.dirname(__FILE__)
LOG_LEVEL = (ENV['LOG_LEVEL'] || '0').to_i
LOGGER = Logger.new('log/nano-blog.log')
LOGGER.level = LOG_LEVEL

DB_DIR = 'db/'.freeze
DB_FILE = File.join(DB_DIR, 'nanoBlog.db').freeze

Bundler.setup(:default, APP_ENV.to_sym)
$LOAD_PATH.unshift File.join(APP_PATH, 'lib')
$LOAD_PATH.unshift File.join(APP_PATH)

# App core
require 'sqlite3'
require 'sequel'

Sequel.sqlite(DB_FILE)

# Lib stuff
require 'nblogger'
require 'store'
require 'init_procedure'
require 'json_payload'
require 'extensions/blank'

# Models
require 'models/log_entry'
require 'models/component'
require 'models/log_entry_template'

# Controllers ¿?
require 'api/components'
require 'api/log_entries'
require 'api/log_entry_templates'

Object.include(Extensions::Blank)
