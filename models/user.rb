class User < Sequel::Model

  def set_password(plain)
    self.password = Auth.encrypt_pass(plain)
  end

  def validate
    super
    errors.add(:username, "can't be empty") if self.username.blank?
    errors.add(:password, "can't be empty") if self.password.blank?
  end

end
