class Component < Sequel::Model

  class << self
    def fetch!(id)
      record = where(id: id).first
      raise ArgumentError, "No component with ID: #{id}" unless record

      record
    end
  end

  def to_h
    {
      id: id,
      name: name
    }
  end

  def to_json
    to_h.to_json
  end

  def validate
    super
    errors.add(:name, "can't be empty") if name.blank?
    errors.add(:name, "already taken") if self.class.where(name: name.upcase).first
  end

  def before_save
    super
    self.name = self.name.upcase unless self.name.blank?
  end
end
