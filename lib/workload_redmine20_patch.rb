require_dependency 'issue'

# Patches Redmine's Issues dynamically.
# Gets redmine < 2.2 compatible
module Workload
  module Redmine20Patch

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
end

# Add module to Issue
Issue.send(:include, Workload::Redmine20Patch) unless Issue.included_modules.include? Workload::Redmine20Patch