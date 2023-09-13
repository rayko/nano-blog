require 'sinatra/base'

module API
  class Components < Sinatra::Base
    use AuthMiddleware
    set :default_content_type, :json

    get '/' do
      [200, {}, Component.all.map(&:to_h).to_json]
    end

    post '/' do
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
      [200, {}, '{}']
    end
  end

end
