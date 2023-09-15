worker_processes (ENV['UNICORN_WORKERS'] || '2').to_i
working_directory "." # available in 0.94.0+
listen 8080, :tcp_nopush => true
timeout (ENV['UNICORN_TIMEOUT'] || '30').to_i
preload_app true
