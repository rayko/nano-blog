class LogEntryTemplate < Sequel::Model

  class << self

    def add!(message, severity, component_id = nil)
      entry = new
      entry.component = Component.fetch!(component_id).name if component_id
      entry.severity = LogEntry.find_severity!(severity)
      entry.message_template = check_template_syntax(message)

      entry.save
    end

    private

    # Dumb syntax check for brackets mostly.
    def check_template_syntax(message)
      stack = []
      message.chars.each do |char|
        if char == '{'
          stack << '{'
        elsif char == '}'
          raise ArgumentError, 'Invalid template message syntax' if stack.empty?
          stack.pop
        end
      end
      raise ArgumentError, 'Invalid template message syntax' if stack.any?
      message
    end

  end

  def component_id
    return nil if component.nil? || component == ''
    record = Component.where(name: component).first
    return nil unless record
    record.id
  end

  def to_h
    {
      id: id,
      component: component,
      component_id: component_id,
      severity: severity,
      message_template: message_template
    }
  end

  def to_json
    to_h.to_json
  end

  def validate
    super
    errors.add(:severity, "can't be empty") if severity.blank?
    errors.add(:message_template, "can't be empty") if message_template.blank?
    unless component.blank?
      errors.add(:component, "doesn't exist") unless Component.where(name: component.upcase).first
    end
  end

  def before_save
    super
    self.component = self.component.upcase unless self.component.blank?
    self.severity = self.severity.upcase
  end
end
