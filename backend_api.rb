require 'sinatra/base'

class BackendAPI < Sinatra::Base
  use API::Components
  use API::LogEntries
  use API::LogEntryTemplates
end
