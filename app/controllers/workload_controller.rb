class WorkloadController < ApplicationController
  unloadable
  menu_item :workload


  helper :issues
  helper :projects
  helper :queries
  include QueriesHelper


  def api_request?
    return User.current.registered?
  end

  def index
    retrieve_query

    @project = Project.find(params[:project_id])
    issues = Issue.workload_estimable(@project)
    members = {}
    for issue in issues
      member = issue.assigned_to
      # create the member key
      unless members[member.id]
        members[member.id] = {:member => member, :issues => []}
      end
      # add issues to this user
      members[member.id][:issues].push(issue)
    end

    @issues = issues
    @member_issues = members
  end
end
