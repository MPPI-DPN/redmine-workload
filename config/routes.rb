get '/projects/:project_id/workload', :to => 'workload#index'
get '/projects/:project_id/workload.json', :to => 'workload#index'

match '/projects/:project_id/workload', :to => 'workload#index', :id => /\d+/, :via => :get
