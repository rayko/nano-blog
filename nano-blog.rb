require 'rubygems'
require 'bundler/setup'
require 'sinatra'

Bundler.require(:defaut, settings.environment.to_sym)

get '/' do
  'Boot complete'
end
