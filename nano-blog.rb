require 'sinatra'

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
  NBLogger.new.tail(20)
end

# TODO Secure this endpoint
post '/feed' do
  message = params[:message]
  severity = params[:severity] || 'info'
  progname = params[:progname]
  level = NBLogger::SEVERITY_MAP.fetch(severity, Logger::INFO)
  log_thing = NBLogger.new.post(message, level, progname)

  204
end
