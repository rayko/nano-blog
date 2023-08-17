require 'sinatra'
require "sinatra/namespace"

set :default_content_type, 'application/json'
set :views, './views'
set :public_folder, './public'

# TODO Return index.html
get '/' do
  content_type :html
  erb :index
end

# TODO Prevent overloading (cache? rate limit?)
get '/feed' do
  logger = NBLogger.new
  output = []
  if params[:after].nil? || params[:after].empty?
    output = logger.read(80)
  else
    output = logger.read(80, params[:after])
  end
  output.to_json
end

# TODO This needs to be behind security
namespace '/admin' do
  get '/index' do
    content_type :html
    erb :admin, locals: { store: Store.new }
  end

  post '/generic-push' do
    severity = params[:severity]
    system_name = params[:subsystem]
    message = params[:message]
    logger = NBLogger.new
    level = NBLogger::SEVERITY_MAP.fetch(severity.downcase.strip, Logger::INFO)
    logger.post(message, level, system_name)
    redirect '/admin/index'
  end

  post '/create-sub-system' do
    new_name = params[:name]
    store = Store.new
    store.add_system_name!(new_name)
    redirect '/admin/index'
  end

  post '/delete-sub-system' do
    new_name = params[:name]
    store = Store.new
    store.remove_system_name!(new_name)
    redirect '/admin/index'
  end
end
