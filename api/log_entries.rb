require 'sinatra/base'
require 'sinatra/namespace'

module API
  class LogEntries < Sinatra::Base
    register Sinatra::Namespace
    set :default_content_type, :json

    namespace '/control/api' do
      post '/log-entries' do
        attrs = JSONPayload.new(request.body.read).parse!
        record = LogEntry.new(attrs)
        begin
          record.save
          [201, {}, record.to_json]
        rescue Sequel::ValidationFailed
          halt 422
        end
      end

      get '/log-entries/last' do
        record = LogEntry.last
        halt 204 unless record
        [200, {}, record.to_json]
      end

      delete '/log-entries/last' do
        record = LogEntry.last
        halt 404 unless record
        record.destroy
        [200, {}, '']
      end
    end

  end
end
