worker_processes 4
working_directory "." # available in 0.94.0+
listen 8080, :tcp_nopush => true
timeout 30
preload_app true

# before_exec do |server|
#   ENV['BUNDLE_GEMFILE'] = "Gemfile"
# end

