Redmine::Plugin.register :redmine_workboard do
  name 'Redmine Workboard plugin'
  author 'Vincent Agnano'
  description 'This is a workload plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://vinyll.github.com'
  permission :workboard, { :workboard => [:index] }, :public => true
  menu :project_menu, :workboard, { :controller => 'workboard', :action => 'index' }, :after => :activity, :param => :project_id

end
