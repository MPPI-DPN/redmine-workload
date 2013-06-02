require 'redmine'

if Redmine::VERSION::MAJOR <= 2 and Redmine::VERSION::MINOR < 2
    require_dependency 'redmine20_patch'
end
require_dependency 'issue_patch'
require_dependency 'user_patch'

Redmine::Plugin.register :redmine_workload do
  name 'Redmine Workload plugin'
  author 'Vincent Agnano'
  description 'This is a workload plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://vinyll.github.com'
  permission :workload, { :workload => [:index] }, :public => true
  menu :project_menu, :workload, { :controller => 'workload', :action => 'index' }, :after => :activity, :param => :project_id
end
