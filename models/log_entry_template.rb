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

end
