require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), 'nano-blog')
# require File.join(File.dirname(__FILE__), 'application')

run Sinatra::Application
