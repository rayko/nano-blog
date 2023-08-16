require 'logger'

# Main handler for nanoblogger actual log.
class NBLogger
  LOGFILE = 'store/nblogger.log'.freeze

  def initialize
    @logger = Logger.new(LOGFILE)
  end

  def tail(size = 10)
    lines = `tail -n #{size} #{LOGFILE}`
  end
end
