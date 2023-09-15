class InitProcedure
  def run!
    default_component = CONFIG.default_component

    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Initializing ..."
    rand_wait
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Loading internal information ..."
    rand_wait
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Loading systems ..."
    rand_wait
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Systems loaded: #{Component.all.map(&:name).join(', ')}"
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Locking target subject ..."
    rand_wait
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Subject: #{CONFIG.subject}"
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Establishing communications channel ..."
    rand_wait
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Opening broadcasting ..."
    rand_wait
    LogEntry.create severity: LogEntry::INFO, component: default_component, message: "Fully operational, all systems up, good day world!"
    nil
  end

  private

  def rand_wait
    sleep rand(3.0)
  end

end
