# frozen_string_literal: true

module UserActions
  class CreateServiceNewUser
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      create_timely_recovery_goal_user_action
      live_goals = [Goal, Announcement, MemberFeedback, Compliance, HealthEducation, HealthEvent].map do |model|
        model.where('end_date > ? AND status = 1', Time.zone.now)
      end
      live_goals.each do |goal_collection|
        goal_collection.each do |actionable|
          next if actionable.nil?

          if UserActions::CreateService.new(actionable).members.include?(user)
            UserActions::CreateService.new(actionable, user: user).call
          end
        end
      end
    end

    def create_timely_recovery_goal_user_action
      actionable = TimelyRecoveryGoal.find_by(timely_recovery_goal_category: 'Program Enrollment')
      return unless actionable.present?

      UserActions::CreateService.new(actionable, user: user).call
    end
  end
end
