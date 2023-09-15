# This is to specifically setup database.

class Schema
  def initialize
    Dir.mkdir('./db') unless Dir.exist?('./db')
  end

  def setup!
    setup_components!
    setup_log_entries!
    setup_log_entry_templates!
    setup_users!
    setup_tokens!
  end

  def db
    @db ||= Sequel.sqlite(DB_FILE)
  end

  private

  def setup_tokens!
    name = :tokens
    return nil if db.table_exists?(name)

    puts "Missing table #{name}, creating ..."
    db.create_table(name) do
      primary_key :id
      String :value
      Integer :expires_at
    end
  end

  def setup_users!
    name = :users
    return nil if db.table_exists?(name)

    puts "Missing table #{name}, creating ..."
    db.create_table(name) do
      primary_key :id
      String :username
      String :password
    end
  end

  def setup_log_entry_templates!
    name = :log_entry_templates
    return nil if db.table_exists?(name)

    puts "Missing table #{name}, creating ..."
    db.create_table(name) do
      primary_key :id
      String :severity
      String :component
      String :message_template
    end
  end

  def setup_components!
    name = :components
    default_component = CONFIG.default_component
    return nil if db.table_exists?(name)

    puts "Missing table #{name}, creating ..."
    db.create_table(name) do
      primary_key :id
      String :name
    end
    db[name].insert(name: default_component) unless db[name].where(name: default_component).any?
  end

  def setup_log_entries!
    name = :log_entries
    return nil if db.table_exists?(name)

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
    db[name].insert(timestamp: Time.now.to_i, severity: 'INFO', component: CONFIG.default_component, message: 'Up and ready!')
  end

end
