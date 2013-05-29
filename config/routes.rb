get '/projects/:project_id/workload', :to => 'workload#index'
match '/projects/:project_id/workload', :to => 'workload#index', :id => /\d+/, :via => :get
