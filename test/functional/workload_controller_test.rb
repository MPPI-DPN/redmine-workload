require File.expand_path('../../test_helper', __FILE__)
require 'active_record'

class WorkloadControllerTest < ActionController::TestCase
  fixtures :users, :projects

  def setup
    #User.current = nil
    @request.session[:user_id] = 1 # admin
    @project = Project.find 3
  end

  test "workload appears in menu" do
    get :index, :project_id => @project.id
    assert_select '#main-menu a.workload.selected', "Workload", "Workload item is selected in the menu"
  end

  test "json is available" do
    get :index, :project_id => @project.id, :format => 'json'
    assert_equal [], JSON.parse(@response.body)
  end

  test "worlkload display message when empty" do
    get :index, :project_id => @project.id
    assert_select '#content p', "There is currently no estimated issue with date constraints for this project."
  end
end
