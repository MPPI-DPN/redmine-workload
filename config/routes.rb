get '/projects/:project_id/workload', :controller => 'workload', :action => 'index'
get '/projects/:project_id/workload.json', :controller => 'workload', :action => 'index'

match '/projects/:project_id/workload', :controller => 'workload', :action => 'index', :via => :get
