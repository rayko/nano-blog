require 'csv'

class DBExporter
  def initialize
    raise StandardError, 'DB dir missing' unless Dir.exist?('./db')
    raise StandardError, 'DB Missing' unless File.exist?(DB_FILE)
  end

  def export!
    export_model(Component)
    export_model(LogEntry)
    export_model(LogEntryTemplate)
    export_model(Token)
    export_model(User)
  end

  def export_model(model)
    header = model.columns
    filename = "db/#{model.name}_data.csv"
    CSV.open(filename, 'w') do |output|
      output << header

      model.each do |item|
        output << header.map{ |col| item.values[col] }
      end
    end
    LOGGER.info "Exported #{filename}"
  end
end
