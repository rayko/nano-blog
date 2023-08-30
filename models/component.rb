class Component < Sequel::Model

  class << self
    def fetch!(id)
      record = where(id: id).first
      raise ArgumentError, "No component with ID: #{id}" unless record

      record
    end
  end

end
