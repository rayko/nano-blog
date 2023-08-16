require 'logger'

# Main handler for nanoblogger actual log.
class NBLogger
  LOGFILE = 'store/nblogger.log'.freeze

  SEVERITY_MAP = { 
    'debug' => Logger::DEBUG,
    'info' => Logger::INFO,
    'warn' => Logger::WARN,
    'fatal' => Logger::FATAL,
    'unknown' => Logger::UNKNOWN,
  }

  def initialize
    @logger = Logger.new(LOGFILE)
  end

  def tail(size = 10)
    lines = `tail -n #{size} #{LOGFILE}`
  end

  def post(txt, level = :info, prog = nil)
    @logger.log level, txt, prog
  end
end
