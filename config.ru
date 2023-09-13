require File.join(File.dirname(__FILE__), 'boot')

routes = {
  '/' => Website,
  '/control/api/components' => API::Components,
  '/control/api/authenticate' => API::Authenticate,
  '/control/api/log-entries' => API::LogEntries,
  '/control/api/log-entry-templates' => API::LogEntryTemplates,
}

run Rack::URLMap.new(routes)
