require 'sinatra/base'

module API
  class LogEntries < Sinatra::Base
    use AuthMiddleware
    set :default_content_type, :json

    post '/' do
      attrs = JSONPayload.new(request.body.read).parse!
      attrs[:timestamp] = Time.now.to_i
      record = LogEntry.new(attrs)
      begin
        record.save
        [201, {}, record.to_json]
      rescue Sequel::ValidationFailed
        halt 422
      end
    end

    get '/last' do
      record = LogEntry.last
      halt 204 unless record
      [200, {}, record.to_json]
    end

    get '/last-message' do
      record = LogEntry.last
      halt 204 unless record
      [200, {}, {id: record.id, message: record.to_message}.to_json]
    end

    delete '/last' do
      record = LogEntry.last
      halt 404 unless record
      record.destroy
      [200, {}, '{}']
    end
  end

end
