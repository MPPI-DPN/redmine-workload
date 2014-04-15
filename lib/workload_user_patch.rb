require_dependency 'user'

# Patches Redmine's Issues dynamically. Adds a relationship
# Issue +belongs_to+ to Deliverable
module Workload
  module UserPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      # Same as typing in the class
      base.class_eval do
        unloadable
      end

    end

    module ClassMethods
    end

    module InstanceMethods
      def issues(project_id)
        return Issue.where(
            "#{Issue.table_name}.project_id = ?
            AND #{Issue.table_name}.assigned_to_id = ?",
            project_id, self.id
        )
      end
      def workload_issues(project)
        return Issue.open().find(
           :all,
           :joins => [:assigned_to],
           :order => "#{User.table_name}.lastname ASC",
           :conditions => 
              ["#{Issue.table_name}.project_id = ?
              AND #{Issue.table_name}.start_date != ?
              AND #{Issue.table_name}.due_date  != ?
              AND #{Issue.table_name}.estimated_hours  != ?
              AND #{Issue.table_name}.assigned_to_id = ?", project, "", "", "", self.id]
          )

      end
      def workload(project)
        issues = self.workload_issues(project)
        schedule = {}

        # make issues into a :date=>:workload schedule
        for issue in issues
            duration = issue[:due_date] - issue[:start_date]
            for i in 0..duration
                date = issue[:start_date] + i
                unless schedule[date]
                    schedule[date] = 0
                end
                schedule[date] += issue.workload
            end
        end

        # merge schedule in following days with same workload into blocks
        # a block is a hash containing :start_date, :due_date and :workload
        blocks = []
        schedule.each do |date, load|
            latest = blocks.last
            # merge block
            if latest and date == latest[:due_date]+1 and load == latest[:workload]
                blocks.last[:due_date] = date
            # or create new block
            else
                blocks << {:start_date => date, :due_date => date, :workload => load}
            end
        end

        return blocks
      end
    end
  end
end

# Add module to Issue
User.send(:include, Workload::UserPatch) unless User.included_module.include? Workload::UserPatch
""" quick testing in console
p = Project.last
u = User.find(4)
u.workload(p)
"""