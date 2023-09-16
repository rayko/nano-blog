require 'csv'

class DBImporter
  def initialize
    raise StandardError, 'DB dir missing' unless Dir.exist?('./db')
    raise StandardError, 'DB Missing' unless File.exist?(DB_FILE)
  end

  def import!
    import_model(Component)
    import_model(LogEntry)
    import_model(LogEntryTemplate)
    import_model(Token)
    import_model(User)
  end

  def import_model(model)
    filename = "db/#{model.name}_data.csv"
    unless File.exist?(filename)
      LOGGER.warn "Expected data file #{filename} does not exist"
      return nil
    end

    CSV.open(filename, 'r') do |data|
      csv_header = data.shift.map(&:to_sym)
      data.each do |row|
        item = csv_header.zip(row).to_h
        item.delete(:id)
        begin
          model.create(item)
        rescue Sequel::ValidationFailed
          LOGGER.warn "Invalid #{model.name}: #{item.inspect}"
        end
      end
    end
    LOGGER.info "Imported #{filename}"
  end
end
