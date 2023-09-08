require 'sinatra/base'
require 'sinatra/namespace'

module API
  class LogEntryTemplates < Sinatra::Base
    register Sinatra::Namespace
    set :default_content_type, :json

    namespace '/control/api' do
      get '/log-entry-templates' do
        [200, {}, LogEntryTemplate.all.map(&:to_h).to_json]
      end

      post '/log-entry-templates' do
        attrs = JSONPayload.new(request.body.read).parse!
        record = LogEntryTemplate.new(attrs)
        begin
          record.save
          [201, {}, record.to_json]
        rescue Sequel::ValidationFailed
          halt 422
        end
      end

      post '/log-entry-templates/:id' do
        attrs = JSONPayload.new(request.body.read).parse!
        template = LogEntryTemplate.where(id: params[:id]).first
        halt 404 unless template

        message_template = template.message_template
        parts = {}
        message_template.scan(/\{[a-z0-9\-_]+\}/).each do |var_name|
          param_name = var_name[1..-2].to_sym
          parts[var_name] = attrs[param_name]
        end
        halt 422 if parts.keys.any? && (parts.values.include?(nil) || parts.values.include?(''))

        parts.each{ |name, val| message_template.gsub!(name, val) }
        entry = LogEntry.new timestamp: Time.now.to_i, severity: attrs[:severity], component: attrs[:component]
        entry.message = message_template
        begin
          entry.save
          [201, {}, entry.to_json]
        rescue Sequel::ValidationFailed
          halt 422
        end
      end

      get '/log-entry-templates/:id' do
        record = LogEntryTemplate.where(id: params[:id]).first
        halt 404 unless record

        [200, {}, record.to_json]
      end

      delete '/log-entry-templates/:id' do
        record = LogEntryTemplate.where(id: params[:id]).first
        halt 404 unless record

        record.destroy
        [200, {}, '{}']
      end
    end

  end
end
