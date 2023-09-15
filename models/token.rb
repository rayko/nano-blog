class Token < Sequel::Model

  class << self
    def generate!
      record = new
      record.value = SecureRandom.urlsafe_base64(64)
      record.expires_at = (Time.now + CONFIG.token_ttl).to_i
      record.save

      record
    end
  end

  def expired?
    Time.now > Time.at(expires_at)
  end

end
