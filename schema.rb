# This is to specifically setup database.

class Schema
  DB_DIR = 'db/'.freeze
  DB_FILE = File.join(DB_DIR, 'nanoBlog.db').freeze

  def initialize
    Dir.mkdir(DB_DIR) unless Dir.exist?(DB_DIR)    
  end

  def setup!
    setup_components!
    setup_log_entries!
  end

  def db
    @db ||= Sequel.sqlite(DB_FILE)
  end

  private

  def setup_components!
    name = :components
    return nil if db.table_exists?(name)

    puts "Missing table #{name}, creating ..."
    db.create_table(name) do
      primary_key :id
      String :name
    end
    db[name].insert(name: 'MONITOR') unless db[name].where(name: 'MONITOR').any?
  end

  def setup_log_entries!
    name = :log_entries
    puts "Missing table #{name}, creating ..."
    db.create_table(name) do
      primary_key :id
      Integer :timestamp
      String :severity
      String :component
      Stirng :message
    end
    db[name].insert(timestamp: Time.now.to_i, severity: 'INFO', message: "** Beginning of stream ** Current Time: #{Time.now.utc} ** FIRST BOOT!")
    db[name].insert(timestamp: Time.now.to_i, severity: 'WARN', message: 'Database non-existent. Creating ...')
    sleep(1)
    db[name].insert(timestamp: Time.now.to_i, severity: 'INFO', message: 'Database created!')
    db[name].insert(timestamp: Time.now.to_i, severity: 'INFO', message: 'Registering component: MONITOR')
    sleep(1)
    db[name].insert(timestamp: Time.now.to_i, severity: 'INFO', component: 'MONTOR', message: 'Up and ready!')
  end

end
