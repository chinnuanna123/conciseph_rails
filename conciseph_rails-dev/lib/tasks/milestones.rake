# frozen_string_literal: true

namespace :milestones do
  desc 'backword compatibilty'
  task update: :environment do
    puts 'task started'
    actionables = ActionStep.pluck(:actionable_type, :actionable_id).uniq
    puts 'actionable_counts'
    puts  actionables.count
    actionables.each do |actionable|
      goal = actionable[0].classify.constantize.find_by(id: actionable[1])
      next if goal.blank? || (goal.present? && goal.milestones.count.positive?)

      milestone = Milestone.create!(
        milestonable_id: goal.id,
        milestonable_type: goal.class.to_s
      )
      action_steps = ActionStep.where(actionable_id: goal.id, actionable_type: goal.class.to_s)
      action_steps.update_all(milestone_id: milestone.id)
    end
    puts 'task ended'
  end
  # desc 'create user_action_milestone'
  # task create_user_action_milestones: :environment do
  #   p 'task starting'
  #   user_actions = UserAction.all
  #   user_actions.each do |user_action|
  #     goal = user_action.actionable
  #     p user_action.id
  #     p goal.blank?
  #     p(user_action.user_action_milestones.count.positive?)
  #     p(goal.present? && goal.milestones.count.zero?)
  #     p '________________________________________'
  #     next if goal.blank? || (goal.present? && goal.milestones.count.zero?)

  #     user_action_milestone = UserActionMilestone.where(
  #       user_action_id: user_action.id,
  #       milestone_id: goal.milestones.first.id
  #     ).first_or_create
  #     p 'updating########'
  #     user_action.user_action_steps.each do |uas|
  #       uas.update!(user_action_milestone_id: user_action_milestone.id)
  #     end
  #     p user_action.user_action_steps.pluck(:user_action_milestone_id)
  #   end
  #   p 'task end'
  # end
end
