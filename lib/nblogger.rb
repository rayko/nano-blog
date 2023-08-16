require 'logger'

# Main handler for nanoblogger actual log.
class NBLogger
  LOGFILE = 'store/nblogger.log'.freeze

  SEVERITY_MAP = { 
    'debug' => Logger::DEBUG,
    'info' => Logger::INFO,
    'warn' => Logger::WARN,
    'error' => Logger::ERROR,
    'fatal' => Logger::FATAL,
    'unknown' => Logger::UNKNOWN,
  }

  def initialize
    @logger = Logger.new(LOGFILE)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      date_format = datetime.utc.strftime("%Y-%m-%d %H:%M:%S UTC")
      if progname.nil? || progname == ''
        "[#{date_format}] -- #{severity} -- #{msg}\n"
      else
        "[#{date_format}] -- #{severity} -- #{progname || 'CORE'} -- #{msg}\n"
      end

    end  
  end

  def tail(size = 10)
    lines = `tail -n #{size} #{LOGFILE}`
  end

  def post(txt, level = nil, prog = nil)
    @logger.log (level || Logger::INFO), txt, prog
  end
end
