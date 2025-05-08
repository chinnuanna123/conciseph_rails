# frozen_string_literal: true

module UserActions
  class FetchCountersSummary
    attr_reader :user

    def initialize(user_or_family_member)
      @user = user_or_family_member
    end

    def call
      {
        announcement_count_hash: announcement_count_hash,
        feedback_count_hash: feedback_count_hash,      
        action_plans_hash: action_plans_hash
      }
    end

    def announcement_count_hash
      user_actions_count(:INNER, [:announcements], :section)
    end

    def action_plans_hash
      {
          Goal.sections.keys[0] => better_health_count,
          TimelyRecoveryGoal.sections.keys[0] => user_actions_count(:INNER, [:timely_recovery_goals])
        }
    end

    def feedback_count_hash
      member_feedback_count_hash = user_actions_count(:INNER, [:member_feedbacks], :section)
      compliance_count_hash =  user_actions_count(:INNER, [:compliances], :section)
      #merging the hashes with same keys ==> values added
      member_feedback_count_hash.merge(compliance_count_hash){ |key, old_val, new_val| old_val + new_val }
    end

    def user_actions_count(join_type, join, group_by = nil, actionable_type = nil)
      hash = { user_id: user.id }
      hash.merge!(actionable_type: actionable_type) if actionable_type.present?
      query = UserAction.where(hash).where(status: ["Not Started", "In Progress"])
      if group_by.present?
        apply_joins(query, join_type, join).group(group_by).count
      else
        apply_joins(query, join_type, join).count
      end
    end

    def apply_joins(query, join_type, associations)
      associations.each do |association|
        query = query.joins(join_query(join_type, association))
      end
      query
    end

    def join_query(join_type, table_name)
      actionable_type = table_name.to_s.camelize.singularize
      "#{join_type} JOIN #{table_name} ON #{table_name}.id = user_actions.actionable_id AND user_actions.actionable_type = '#{actionable_type}'"
    end

    def commom_query_hash
      {user_id: user.id, status: ["Not Started", "In Progress"]}
    end

    def better_health_count
      [
        UserAction.joins(join_query(:INNER, 'goals')).where(commom_query_hash.merge(goals: { section: 0 })).count,
        UserAction.joins(join_query(:INNER, 'health_events')).where(commom_query_hash.merge(health_events: { section: 0 })).count,
        UserAction.joins(join_query(:INNER, 'health_educations')).where(commom_query_hash.merge(health_educations: { section: 0 })).count
      ].sum
    end
  end
end
