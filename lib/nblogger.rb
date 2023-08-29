require 'logger'

# Main handler for nanoblogger actual log.
class NBLogger
  LOGFILE = 'store/nblogger.log'.freeze
  SEVERITIES = %w[INFO WARN DEBUG CRITICAL UNKNOWN ERROR].freeze

  def initialize
  end

  def tail(size = 10)
    lines = `tail -n #{size} #{LOGFILE}`
  end

  def append(txt, severity, prog = nil)
    File.open(LOGFILE, 'a') do |file|
      unless prog.nil? || prog == ''
        file << "[#{Time.now.utc}] -- #{severity} -- #{prog.upcase} -> #{txt}\n"
      else
        file << "[#{Time.now.utc}] -- #{severity} -> #{txt}\n"
      end
    end
    nil
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
    return 'critical' if line =~ /CRITICAL/
    return 'unknown' if line =~ /UNKNOWN/

    nil
  end
end
