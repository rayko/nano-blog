require 'sinatra'

get '/' do
  'Boot complete'
end

get '/feed' do
  NBLogger.new.tail(20)
end

post '/feed' do
  message = params[:message]
  severity = params[:severity] || 'info'
  progname = params[:progname]
  level = NBLogger::SEVERITY_MAP.fetch(severity, Logger::INFO)
  log_thing = NBLogger.new.post(message, level, progname)
end
