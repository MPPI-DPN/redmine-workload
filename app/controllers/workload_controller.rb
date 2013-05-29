class WorkloadController < ApplicationController
  unloadable
  menu_item :workload


  helper :issues
  helper :projects
  helper :queries
  include QueriesHelper

  def index
    retrieve_query

    @project = Project.find(params[:project_id])
    issues = Issue.open(true).where(
      "project_id = ?
      AND start_date != ''
      AND due_date  != ''
      AND estimated_hours  != ''", @project)
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

    @member_issues = members
    @date_range = [
      issues.order(:start_date).first.start_date.to_date,
      issues.order(:due_date).last.due_date.to_date
    ]
  end
end
