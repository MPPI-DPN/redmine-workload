require 'active_record'
require 'test_helper'


class UserPatchTest < ActionController::TestCase
  fixtures :users, :projects, :issues, :issue_statuses

  def setup
        @user = User.find(3)
        issues = @user.issues(1)
  end

  def test_workload
    assert_equal [], @user.workload_issues(1)
  end

end