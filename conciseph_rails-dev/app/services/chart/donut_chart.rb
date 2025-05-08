module Chart
  class DonutChart
    attr_accessor :actionable, :user_actions

    def initialize(actionable)
      @actionable = actionable
      @user_actions = actionable.user_actions
    end

    def call
      {
        outreach: outreach_data.values,
        outreach_percentage: outreach_percentage,
        completion: completion_data.values,
        completion_percentage: completion_percentage
      }
    end

    private

    # Outreach Data
    def outreach_data
      default_outreach_hash.merge(grouped_outreach_data)
    end

    def grouped_outreach_data
      user_actions
        .group("CASE WHEN user_actions.acknowledge_at IS NULL THEN 'not_acknowledged' ELSE 'acknowledged' END")
        .count
        .symbolize_keys
    end

    def outreach_percentage
      acknowledged = grouped_outreach_data[:acknowledged].to_i
      total = grouped_outreach_data.values.sum
      calculate_percentage(acknowledged, total)
    end

    # Completion Data
    def completion_data
      default_completion_hash.merge(grouped_completion_data)
    end

    def grouped_completion_data
      user_actions.group(:status).count.symbolize_keys
    end

    def completion_percentage
      completed = grouped_completion_data[:completed].to_i
      total = grouped_completion_data.values.sum
      calculate_percentage(completed, total)
    end

    # Utility Methods
    def calculate_percentage(value, total)
      return 0 if total.zero?
      ((value.to_f / total) * 100).round(2)
    end

    def default_outreach_hash
      { acknowledged: 0, not_acknowledged: 0 }
    end

    def default_completion_hash
      { 'Completed': 0, 'In Progress': 0,'Not Started': 0 }
    end
  end
end
