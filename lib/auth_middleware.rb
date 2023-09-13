class AuthMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    auth_header = env['HTTP_AUTHORIZATION']
    return unauthorized if auth_header.blank?
    return unauthorized unless auth_header =~ /^Bearer /

    auth_token = auth_header.split(' ').last
    return unauthorized if auth_token.blank?

    token = Token.where(value: auth_token).first
    return unauthorized unless token
    return unauthorized if token.expired?

    @app.call(env)
  end

  def unauthorized
    Rack::Response.new([], 401, {}).finish
  end

end
