class Auth

  class << self
    def secure_compare(a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    def encrypt_pass(pass)
      BCrypt::Password.create(pass).to_s
    end

    def check(hash_pass, pass)
      return false if hash_pass.blank?

      bcrypt = BCrypt::Password.new(hash_pass)
      password = BCrypt::Engine.hash_secret(pass, bcrypt.salt)
      secure_compare(password, hash_pass)
    end
  end
end
