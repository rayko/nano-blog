# Manager of tiny assets required across various places, like store dir, categories, form items, etc.

class Store
  STORE_PATH = './store/'.freeze

  def initialize
    Dir.mkdir(STORE_PATH) unless Dir.exist?(STORE_PATH)
  end

  def severity_items
    NBLogger::SEVERITIES
  end

  def system_names
    fetch('system_names.json') || []
  end

  def set_subject_info(name)
    write! 'subject.json', { 'name' => name }.to_json
  end

  def subject_info
    fetch('subject.json') || { 'name' => 'UNKNOWN'}
  end

  def add_system_name!(name)
    return nil if name.nil? || name.empty?
    return nil if system_names.include?(name.upcase.strip)

    items = system_names
    items << name.upcase.strip
    items.uniq!
    write! 'system_names.json', items.to_json
    NBLogger.new.append("Registring new system: #{name.upcase.strip}", 'INFO', 'MONITOR')
    nil
  end

  def remove_system_name!(name)
    return nil if name.nil? || name.empty?
    return nil unless system_names.include?(name.upcase.strip)

    items = system_names
    items.delete name.upcase.strip
    write! 'system_names.json', items.to_json
    NBLogger.new.append("De-registring system: #{name.upcase.strip}", 'INFO', 'MONITOR')
    nil
  end

  private

  def write!(json_file, json_data)
    filepath = build_path(json_file)
    File.open(filepath, 'w'){ |f| f << json_data }
  end

  def fetch(json_file)
    filepath = build_path(json_file)
    return nil unless File.exist?(filepath)
    
    data = File.read(filepath)
    return nil if data.nil? || data.empty?

    JSON.parse(File.read(filepath))
  end

  def build_path(file)
    [STORE_PATH, file].join('/')
  end
end
