class WorkboardController < ApplicationController
  unloadable
  menu_item :workload


  helper :issues
  helper :projects
  helper :queries
  include QueriesHelper

  def index
    retrieve_query

    @project = Project.find(params[:project_id])
    issues = Issue.open(true).where("project_id = ?", @project)
    members = {}
    for issue in issues
      member = issue.assigned_to
      members[member.id] = {:member => member, :issues => []}
      members[member.id][:issues].push(issue)
    end

    @member_issues = members
  end
end
