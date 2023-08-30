class LogEntry < Sequel::Model
  INFO = 'INFO'.freeze
  WARN = 'WARN'.freeze
  DEBUG = 'DEBUG'.freeze
  CRIT = 'CRIT'.freeze
  ERROR = 'ERROR'.freeze
  UNKNOWN = '???'.freeze

  SEVERITIES = [INFO, WARN, DEBUG, CRIT, ERROR, UNKNOWN]

  class << self

    def post!(message, severity, component_id = nil)
      entry = new(timestamp: Time.now.to_i)
      entry.component = Component.fetch!(component_id).name if component_id
      entry.severity = find_severity!(severity)
      entry.message = message

      entry.save
    end

    private

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

end
