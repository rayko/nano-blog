class LogEntry < Sequel::Model
  INFO = 'INFO'.freeze
  WARN = 'WARN'.freeze
  DEBUG = 'DEBUG'.freeze
  CRIT = 'CRIT'.freeze
  ERROR = 'ERROR'.freeze
  UNKNOWN = '???'.freeze

  SEVERITIES = [INFO, WARN, DEBUG, CRIT, ERROR, UNKNOWN]

  class << self
    def find_severity!(severity)
      name = severity.upcase

      return INFO if name == 'INFO'
      return WARN if name == 'WARN'
      return DEBUG if name == 'DEBUG'
      return CRIT if name == 'CRIT'
      return ERROR if name == 'ERROR'
      return UNKNOWN if name == '???'

      raise ArgumentError, "Invalid severity: #{severity}"
    end
  end

  def to_message
    return "[#{date}] -- #{severity} -> #{message}" if component.blank?
    "[#{date}] -- #{severity} -- #{component} -> #{message}"
  end
  
  def to_h
    {
      timestamp: date,
      severity: severity,
      component: component,
      message: message
    }
  end

  def to_json
    to_h.to_json
  end

  def date
    Time.at(timestamp).utc.strftime('%Y-%m-%d %H:%M:%S UTC')
  end

  def validate
    super
    errors.add(:severity, "can't be empty") if severity.blank?
    errors.add(:message, "can't be empty") if message.blank?
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
