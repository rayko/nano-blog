class InitProcedure
  def run!
    blog = NBLogger.new
    store = Store.new
    unless store.system_names.include? 'MONITOR'
      store.add_system_name! 'MONITOR'
    end

    blog.append "Initializing ...", 'INFO', 'MONITOR'
    rand_wait
    blog.append 'Loading internal information ...', 'INFO', 'MONITOR'
    rand_wait
    blog.append 'Loading systems ...', 'INFO', 'MONITOR'
    rand_wait
    blog.append "Systems loaded: #{store.system_names.join(', ')}", 'INFO', 'MONITOR'
    blog.append "Locking target subject ...", 'INFO', 'MONITOR'
    rand_wait
    blog.append "Subject: #{store.subject_info['name']}", 'INFO', 'MONITOR'
    if store.subject_info['name'] == 'UNKNOWN'
      blog.append "Unable to target subject", 'ERROR', 'MONITOR'
      blog.append "Unable to monitor", 'ERROR', 'MONITOR'
      blog.append "Unable to find purpose", 'CRITICAL', 'MONITOR'
    else
      blog.append "Establishing communications channel ...", 'INFO', 'MONITOR'
      rand_wait
      blog.append "Opening broadcasting ...", 'INFO', 'MONITOR'
      rand_wait
      blog.append "Fully operational, all systems up, good day world!", 'INFO', 'MONITOR'
    end
    nil
  end

  private

  def rand_wait
    sleep rand(3.0)
  end

end
