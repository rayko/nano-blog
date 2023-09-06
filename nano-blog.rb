require 'sinatra'
require "sinatra/namespace"

set :default_content_type, 'application/json'
set :views, './views'
set :public_folder, './public'

use API::Components
use API::LogEntries
use API::LogEntryTemplates

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

  post '/generic-push' do
    severity = params[:severity]
    component_id = params[:component_id]
    component = Component.where(id: component_id).first
    message = params[:message]
    LogEntry.post! message, severity, component_id
    redirect '/control/index'
  end

  post '/template-push' do
    template = LogEntryTemplate.where(id: params[:template_id]).first
    return redirect('/control/index') unless template

    message_template = template.message_template
    parts = {}
    message_template.scan(/\{[a-z0-9\-_]+\}/).each do |var_name|
      param_name = var_name[1..-2].to_sym
      parts[var_name] = params[param_name]
    end

    return redirect('/control/index') if parts.keys.any? && (parts.values.include?(nil) || parts.values.include?(''))

    parts.each{ |name, val| message_template.gsub!(name, val) }
    LogEntry.post! message_template, template.severity, template.component_id
    redirect '/control/index'
  end

  post '/components'do
    name = (params[:name] || '').upcase.strip
    unless name == '' || Component.where(name: name).any?
      Component.create(name: name)
    end
    redirect '/control/index'
  end

  delete '/components/:id' do
    component_id = params[:id].to_i
    component = Component.where(id: component_id).first
    if component
      component.delete
    end
    redirect '/control/index'
  end

  post '/log-entry-templates' do
    severity = params[:severity] || ''
    component_id = (params[:component_id] || '').to_i
    component = Component.where(id: component_id).first
    msg = params[:message] || ''

    unless severity == '' || msg == ''
      template = LogEntryTemplate.new severity: severity
      template.component = component.name if component
      template.message_template = msg
      template.save
    end

    redirect '/control/index'
  end

  delete '/log-entry-templates/:id' do
    template_id = params[:id].to_i
    template = LogEntryTemplate.where(id: template_id).first
    if template
      template.delete
    end
    redirect '/control/index'
  end

end
