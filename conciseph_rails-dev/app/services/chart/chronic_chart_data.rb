# frozen_string_literal: true

module Chart
  class ChronicChartData
    attr_reader :listing

    def initialize(listing = false)
      @listing = listing
    end

    def call
      data
    end

    def data
      {
        health_event_data: health_event_participation,

        health_education_data: health_education_completeness,

        member_feedback_data: feedback_surveys_completeness,

        nutrition_therapy_completeness_data: nutrition_therapy_completeness,

        medication_refill_adherence: medication_refill_adherence,

        hbac: hbac,
        medication_adherence: medication_adherence,
        schedule_adherence: schedule_adherence,
        support_needs: support_needs
      }
    end

    def medication_refill_adherence
      initial_query = UserAction.includes(:user, :actionable, :medication).joins(join_query('TimelyRecoveryGoal', 112))
      return initial_query if listing

      timely_recovery_goal = initial_query.group(:status).count

      timely_recovery_goal.default = 0
      timely_recovery_goal_hash = transform_hash(timely_recovery_goal)
      {
        "Medication Refill Completed": timely_recovery_goal_hash['action plan completed'],
        "Medication Refill Not Completed": timely_recovery_goal_hash['action plan not completed']
      }
    end

    def medication_adherence
      initial_query = Medication.eager_load(:medication_timings,
                                            :user).where("medications.updated_at >= CURRENT_DATE - INTERVAL '90 days'")
      return initial_query if listing

      medication = initial_query.group(:status).count
      result = {
        'Medication Adherance': medication['On Track'].to_i,
        'Medication Non Adherance': medication['Non Adherence'].to_i
      }
      
      if result.values.count{|e| e != 0 } >= 1
        return result
      else
        {
        'Medication Adherance': 0,
        'Medication Non Adherance':0
        }
      end
    end

    def health_event_participation
      initial_query = UserAction.includes(:user, :actionable).joins(join_query('HealthEvent', 1))
      return initial_query if listing

      health_event = initial_query.group(:status).count
      health_event.default = 0
      health_event_hash = transform_hash(health_event)
      {
        "Event Action Completed": health_event_hash['action plan completed'],
        "Event Action Not Completed": health_event_hash['action plan not completed']
      }
    end

    def health_education_completeness
      initial_query = UserAction.includes(:user, :actionable).joins(join_query('HealthEducation', 2))
      return initial_query if listing

      health_education = initial_query.group(:status).count

      health_education.default = 0
      health_education_hash = transform_hash(health_education)
      {
        "Education Action Plan Completed": health_education_hash['action plan completed'],
        "Education Action Plan Not Completed": health_education_hash['action plan not completed']
      }
    end

    def feedback_surveys_completeness
      initial_query = UserAction.includes(:user, :actionable).joins(join_query('MemberFeedback', 6))
      return initial_query if listing

      member_feedback = initial_query.group(:status).count

      member_feedback.default = 0
      member_feedback_hash = transform_hash(member_feedback)
      {
        "Feedback/Survey Completed": member_feedback_hash['action plan completed'],
        "Feedback/Survey Not Completed": member_feedback_hash['action plan not completed']
      }
    end

    def nutrition_therapy_completeness
      initial_query = UserAction.includes(:user, :actionable).joins(join_query('Goal', 2))
      return initial_query if listing

      goal = initial_query.group(:status).count
      goal.default = 0
      goal_hash = transform_hash(goal)
      {
        "Therapy Plan Completed": goal_hash['action plan completed'],
        "Therapy Plan Not Completed": goal_hash['action plan not completed']
      }
    end

    def hbac
      result_hash = {
        'Above 6.4' => 0,
        'Below 5.6' => 0,
        'between 5.7 and 6.4' => 0
      }
      initial_query = Vital.eager_load(:user).where(vital_type: 'Hbac')
                           .where('vitals.updated_at >= ?', Date.today - 90.days)
      return initial_query if listing

      vital_hbac = initial_query.group(group_query).count
      if vital_hbac.values.count{|e| e != 0 } >= 1 #checking for non-zero elements
        result_hash.merge!(vital_hbac)
      else
        result_hash.merge!({
          'Above 6.4' => 0,
          'Below 5.6' => 0,
          'between 5.7 and 6.4' => 0
        })
      end
    end

    def schedule_adherence
      initial_query = User.where("updated_at >= CURRENT_DATE - INTERVAL '90 days'").where.not(medication_adhere_status: 'Not Started')
      return initial_query.where(medication_adhere_status: 'Non Adherence') if listing

      schedule_adherence_hash = initial_query.group(:medication_adhere_status).count
      {
        "Non Adherence": schedule_adherence_hash['Non Adherence'].to_i,
        
      }
    end

    def support_needs
      # support_needs_hash = SupportNeed.group(:name).distinct.count(:user_id)
      
      User.left_joins(:support_needs).group('support_needs.code').count.map{|k,v| [SupportNeed.codes.key(k.to_i), v]  }.to_h
    end

    def group_query
      "CASE
        WHEN vitals.value >6.4 then 'Above 6.4'
        WHEN vitals.value BETWEEN 5.7 AND 6.4 THEN 'between 5.7 and 6.4'
        WHEN vitals.value <=5.6 THEN 'Below 5.6'
      END"
    end

    def join_query(model_name, category)
      table_name = model_name.pluralize.underscore
      category_name = "#{model_name.underscore}_category"
      "INNER JOIN #{table_name} ON #{table_name}.id = user_actions.actionable_id AND user_actions.actionable_type = '#{model_name}' AND #{table_name}.#{category_name} = #{category} AND #{table_name}.updated_at >= CURRENT_DATE - INTERVAL '90 days'"
    end

    def transform_hash(hash)
      return { 'action plan not completed' => 0, 'action plan completed' => 0 } if hash.empty?

      val ||= 0
      hash.each_with_object({}) do |(k, v), new_hash|
        if ['In Progress', 'Not Started'].include?(k)
          val += v.to_i
        else
          new_hash['action plan completed'] = v.to_i
        end
        new_hash['action plan not completed'] = val
        new_hash['action plan completed'] = 0 unless new_hash.key?('action plan completed')
      end
    end
  end
end
