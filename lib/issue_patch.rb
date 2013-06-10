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
        self.open().find(
          :all,
          :conditions => [
            "#{Issue.table_name}.project_id = ?
            AND #{Issue.table_name}.start_date != ?
            AND #{Issue.table_name}.due_date  != ?
            AND #{Issue.table_name}.estimated_hours  != ?",
            project, "", "", ""],
          :joins => [:assigned_to],
          :order => "#{User.table_name}.lastname ASC"
        )
      }
    end

    def workload_estimable_by_member(project)
      return self.workload_estimable(project)
    end

  end

  module ClassMethods
  end

  module InstanceMethods
    # Returns the duration in working days
    def working_duration
      (start_date && due_date) ? working_days(start_date, due_date) : 0
    end

    def workload
      estimate = self.estimated_hours.to_f
      duration = self.working_duration.to_f + 1.0
      if estimate > 0 and duration > 0
        return (estimate / duration).round
      end
      return 0
    end



    ###### REDMINE < 2.3 2.2(?) #######

    # Returns the number of working days between from and to
    def working_days(from, to)
      days = (to - from).to_i
      if days > 0
        weeks = days / 7
        result = weeks * (7 - non_working_week_days.size)
        days_left = days - weeks * 7
        start_cwday = from.cwday
        days_left.times do |i|
          unless non_working_week_days.include?(((start_cwday + i - 1) % 7) + 1)
            result += 1
          end
        end
        result
      else
        0
      end
    end

    # Adds working days to the given date
    def add_working_days(date, working_days)
      if working_days > 0
        weeks = working_days / (7 - non_working_week_days.size)
        result = weeks * 7
        days_left = working_days - weeks * (7 - non_working_week_days.size)
        cwday = date.cwday
        while days_left > 0
          cwday += 1
          unless non_working_week_days.include?(((cwday - 1) % 7) + 1)
            days_left -= 1
          end
          result += 1
        end
        next_working_date(date + result)
      else
        date
      end
    end

    # Returns the date of the first day on or after the given date that is a working day
    def next_working_date(date)
      cwday = date.cwday
      days = 0
      while non_working_week_days.include?(((cwday + days - 1) % 7) + 1)
        days += 1
      end
      date + days
    end

    # Returns the index of non working week days (1=monday, 7=sunday)
    def non_working_week_days
      @non_working_week_days ||= begin
        days = [] # Setting.non_working_week_days
        if days.is_a?(Array) && days.size < 7
          days.map(&:to_i)
        else
          []
        end
      end
    end
  end
end

# Add module to Issue
Issue.send(:include, IssuePatch)