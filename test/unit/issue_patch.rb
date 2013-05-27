require 'active_record'
require 'active_record/fixtures'
require 'test_helper'
require 'issue_patch'

#Fixtures.create_fixtures("../fixtures/issues.yaml", ActiveRecord::Base.connection.tables)


class IssuePatchTest < ActionController::TestCase
  fixtures :users, :projects, :issues, :issue_statuses

  def setup
    @issue = Issue.find(3)
  end

  def test_make_sure_its_all_fine
    assert_equal 10, @issue.duration
    assert_equal 7, @issue.working_duration
    assert_equal 0, @issue.estimated_hours.to_i
  end

  def test_workload
    assert_equal 0, @issue.workload
    @issue.estimated_hours = 20
    assert_equal 3, @issue.workload
  end

end