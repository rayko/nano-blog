class JSONPayload

  def initialize(data)
    @data = data
  end

  def parse!
    return nil if @data.blank?

    result = {}
    begin
      JSON.parse(@data).each do |key, value|
        result[key.to_sym] = value unless value.blank?
      end
    rescue JSON::ParserError
      return nil
    end

    result
  end

end
