require 'sinatra'
require "sinatra/namespace"

set :default_content_type, 'application/json'
set :views, './views'
set :public_folder, './public'

# use API::Components
# use API::LogEntries
# use API::LogEntryTemplates
# use API::Authenticate

# TODO Return index.html
get '/' do
  content_type :html
  erb :index
end

# TODO Prevent overloading (cache? rate limit?)
get '/feed' do
  output = []
  after_id = params[:after_id].to_i
  if after_id == 0
    last_entry = LogEntry.last
    after_id = (last_entry ? last_entry.id - 80 : 0)
  end
  LogEntry.where{id > after_id}.each { |entry| output << { id: entry.id, message: entry.to_message, severity: entry.severity} }
  output.to_json
end

get '/control' do
  redirect '/control/index'
end

get '/control/' do
  redirect '/control/index'
end

# TODO This needs to be behind security
namespace '/control' do
  get '/index' do
    content_type :html
    erb :control, locals: { store: Store.new }
  end

  get '/login' do
    content_type :html
    erb :login
  end
end
