require 'sinatra/base'
# require "sinatra/namespace"

class BackendAPI < Sinatra::Base
  register Sinatra::Namespace

  set :default_content_type, :json

  namespace '/control/api' do
    namespace '/components' do
      get '' do
        [200, {}, Component.all.map(&:to_h).to_json]
      end

      post '' do
        attrs = JSONPayload.new(request.body.read).parse!
        record = Component.new(attrs)
        begin
          record.save
          [201, {}, record.to_json]
        rescue Sequel::ValidationFailed
          halt 422
        end
      end

      get '/:id' do
        record = Component.where(id: params[:id]).first
        halt 404 unless record

        [200, {}, record.to_json]
      end

      delete '/:id' do
        record = Component.where(id: params[:id]).first
        halt 404 unless record
        halt 423 if record.name == 'MONITOR'

        record.destroy
        [200, {}, '']
      end

    end

    namespace '/log-entries' do
      post '' do
        attrs = JSONPayload.new(request.body.read).parse!
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

      delete '/last' do
        record = LogEntry.last
        halt 404 unless record
        record.destroy
        [200, {}, '']
      end
    end

    namespace '/log-entry-templates' do
      get '' do
        [200, {}, LogEntryTemplate.all.map(&:to_h).to_json]
      end

      post '' do
        attrs = JSONPayload.new(request.body.read).parse!
        record = LogEntryTemplate.new(attrs)
        begin
          record.save
          [201, {}, record.to_json]
        rescue Sequel::ValidationFailed
          halt 422
        end
      end

      get '/:id' do
        record = LogEntryTemplate.where(id: params[:id]).first
        halt 404 unless record

        [200, {}, record.to_json]
      end

      delete '/:id' do
        record = LogEntryTemplate.where(id: params[:id]).first
        halt 404 unless record

        record.destroy
        [200, {}, '']
      end
      
    end

    get '/ping' do
      'PONG'
    end
  end

end
