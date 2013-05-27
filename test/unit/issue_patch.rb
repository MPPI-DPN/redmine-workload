require 'active_record'
require 'test_helper'


class IssuePatchTest < ActionController::TestCase
  fixtures :users, :projects, :issues, :issue_statuses

  def setup
    @issue = Issue.find(3)
    @empty_issue = Issue.new
  end

  def test_make_sure_its_all_fine
    assert_equal 10, @issue.duration
    assert_equal 7, @issue.working_duration
    assert_equal 0, @issue.estimated_hours.to_i
  end

  def test_workload
    assert_equal 0, @empty_issue.workload
    assert_equal 0, @issue.workload
    @issue.estimated_hours = 20
    assert_equal 3, @issue.workload
  end

end