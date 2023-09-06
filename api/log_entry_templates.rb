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

      get '/log-entry-templates/:id' do
        record = LogEntryTemplate.where(id: params[:id]).first
        halt 404 unless record

        [200, {}, record.to_json]
      end

      delete '/log-entry-templates/:id' do
        record = LogEntryTemplate.where(id: params[:id]).first
        halt 404 unless record

        record.destroy
        [200, {}, '']
      end
    end

  end
end
