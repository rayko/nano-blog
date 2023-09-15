class Configs
  attr_reader :subject, :default_component, :token_ttl, :log_level

  def initialize
    load_config!
  end

  private

  def load_config!
    @subject = ENV['NB_SUBJECT']
    @default_component = ENV['NB_DEFAULT_COMPONENT']
    @token_ttl = ENV['NB_TOKEN_TTL'] || 21600 # 6 hour
    @log_level = ENV['NB_LOG_LEVEL']

    check_values!
    convert_values!
  end

  def check_values!
    raise StandardError, 'NB_SUBJECT not set' if subject.blank?
    raise StandardError, 'NB_DEFAULT_COMPONENT not set' if default_component.blank?
    raise StandardError, 'NB_TOKEN_TTL not set' if token_ttl.blank?
    raise StandardError, 'NB_LOG_LEVEL not set' if log_level.blank?
  end

  def convert_values!
    @log_level = @log_level.to_i
    @token_ttl = @token_ttl.to_i
  end
    
end
