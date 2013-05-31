require_dependency 'issue'

# Patches Redmine's Issues dynamically. Adds a relationship
# Issue +belongs_to+ to Deliverable
module IssuePatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    # Same as typing in the class
    base.class_eval do
      unloadable
      scope :workload_estimable, lambda {|project|
        self.open().where(
          "#{Issue.table_name}.project_id = ?
          AND #{Issue.table_name}.start_date != ?
          AND #{Issue.table_name}.due_date  != ?
          AND #{Issue.table_name}.estimated_hours  != ?",
          project, "", "", "")
      }
    end

    def workload_estimable_by_member(project)
      return self.workload_estimable(project)
    end

  end

  module ClassMethods
  end

  module InstanceMethods
    def workload
      estimate = self.estimated_hours.to_f
      duration = self.working_duration.to_f + 1.0
      if estimate > 0 and duration > 0
        return (estimate / duration).round
      end
      return 0
    end
  end
end

# Add module to Issue
Issue.send(:include, IssuePatch)