require 'sinatra/base'

module API
  class Authenticate < Sinatra::Base
    set :default_content_type, :json

    post '/' do
      attrs = JSONPayload.new(request.body.read).parse! || {}
      auth_string = attrs[:auth]
      halt 400 if auth_string.blank?

      user, pass = Base64.decode64(auth_string).split(':')
      halt 400 if user.blank? || pass.blank?

      user_record = User.where(username: user).first
      halt 400 unless user_record
      
      if Auth.check(user_record.password, pass)
        token = Token.last
        token = Token.generate! if token.blank? || token.expired?
        [200, {}, { token: token.value }.to_json ]
      else
        halt 400
      end

    end
  end

end
