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
        "[#{date_format}] -- #{severity} -> #{msg}\n"
      else
        "[#{date_format}] -- #{severity} -- #{progname || 'CORE'} -> #{msg}\n"
      end

    end  
  end

  def tail(size = 10)
    lines = `tail -n #{size} #{LOGFILE}`
  end

  def post(txt, level = nil, prog = nil)
    @logger.log (level || Logger::INFO), txt, prog
  end

  def read(size = 10, after = nil)
    lines = tail(size)
    return {} if lines.nil? || lines.empty?

    output = []
    hashes = []
    lines.split("\n").each do |line|
      hash = Digest::SHA256.hexdigest(line)
      hashes << hash
      output << { message: line, hash: hash, level: level_from_message(line) }
    end

    if after && hashes.index(after)
      index_limit = hashes.index(after)
      output.shift(index_limit + 1)
    end

    output
  end

  private

  def level_from_message(line)
    return 'debug' if line =~ /DEBUG/
    return 'info' if line =~ /INFO/
    return 'warn' if line =~ /WARN/
    return 'error' if line =~ /ERROR/
    return 'fatal' if line =~ /FATAL/
    return 'unknown' if line =~ /UNKNOWN/

    nil
  end
end
