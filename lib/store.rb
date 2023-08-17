# Manager of tiny assets required across various places, like store dir, categories, form items, etc.

class Store
  STORE_PATH = './store/'.freeze

  def initialize
    Dir.mkdir(STORE_PATH) unless Dir.exist?(STORE_PATH)
  end

  def severity_items
    %w[info warn debug error fatal unknown]
  end

  def system_names
    fetch('system_names.json') || []
  end

  def add_system_name!(name)
    return nil if name.nil? || name.empty?

    items = system_names
    items << name.upcase.strip
    items.uniq!
    write! 'system_names.json', items.to_json
    nil
  end

  def remove_system_name!(name)
    return nil if name.nil? || name.empty?

    items = system_names
    items.delete name.upcase.strip
    write! 'system_names.json', items.to_json
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
