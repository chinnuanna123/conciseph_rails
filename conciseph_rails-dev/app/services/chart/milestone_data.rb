# frozen_string_literal: true

# goal                        user_actions
#   milestones                  user_action_milestones
#     actionsteps                 user_action_step

# 1

# app/service/chart/milestone_data.rb
module Chart
  class MilestoneData
  
    def milestone_data(goal)
      milestones = goal.milestones.order(created_at: :asc)
      result = { name: [], completed: [], in_progress: [], not_started: [], chart_labels: [], milestone_ids: [] }
  
      milestones.each_with_index do |milestone, index|
        status_wise_completion = UserActionMilestone.where(milestone_id: milestone.id).group(:status).count
        next if status_wise_completion.blank?
  
        total = status_wise_completion.values.sum
        result = merge_into_result(result, status_wise_completion, total, milestone.id, index)
      end
      result
    end
  
    private
  
    def merge_into_result(result, status_wise_completion, total, milestone_id, index)
      result[:name] << "Milestone-#{index + 1}"
      result[:completed] << calculate_percentage(status_wise_completion['Completed'] || 0, total)
      result[:in_progress] << calculate_percentage(status_wise_completion['In Progress'] || 0, total)
      result[:not_started] << calculate_percentage(status_wise_completion['Not Started'] || 0, total)
      result[:chart_labels] << [status_wise_completion['Completed'], status_wise_completion['In Progress'], status_wise_completion['Not Started']]
      result[:milestone_ids] << milestone_id
      result
    end
  
    def calculate_percentage(number, total)
      ((number / total.to_f) * 100).round
    end
  end
end
