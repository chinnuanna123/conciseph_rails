# frozen_string_literal: true

module Dashboard
  class CountersService
    include Rails.application.routes.url_helpers
    
    def call
      counter_data
    end

    private

    def counter_data
      [
        quality_measure_goals,
        timely_interventions_goals,
        chronic_conditions_management_goals,
        care_management_goals,
        health_education,
        feedback_surveys,
        announcements,
        health_event_goals,
        compliance_goals,
        member_engagement,
        chronic_condition_management_dashboard
      ]
    end

    def quality_measure_goals
      {
        title: 'Quality Measure Goals',
        count: Goal.count,
        show_counter: true,
        link: goals_path
      }
    end

    def timely_interventions_goals
      {
        title: 'Timely Interventions Goals',
        count: TimelyRecoveryGoal.count,
        show_counter: true,
        link: timely_recovery_goals_path
      }
    end

    def chronic_conditions_management_goals
      {
        title: 'Condition Management Goals',
        icon: 'ti-heart',
        count: ChronicConditionManagementGoal.count,
        show_counter: true,
        link: chronic_condition_management_goals_path
      }
    end

    def care_management_goals
      {
        title: 'Care Management',
        icon: 'ti-user',
        count: CareManagement.count,
        show_counter: true,
        link: care_managements_path
      }
    end

    def health_education
      {
        title: 'Health Education',
        count: HealthEvent.count,
        show_counter: true,
        link: health_educations_path
      }
    end

    def feedback_surveys
      {
        title: 'Feedback / Surveys',
        count: MemberFeedback.count,
        show_counter: true,
        link: member_feedbacks_path
      }
    end

    def announcements
      {
        title: 'Announcements',
        count: Announcement.count,
        show_counter: true,
        link: announcements_path
      }
    end

    def health_event_goals
      {
        title: 'Health Event Goals',
        count: HealthEvent.count,
        show_counter: true,
        link: health_events_path
      }
    end

    def compliance_goals
      {
        title: 'Compliance Goals',
        count: Compliance.count,
        show_counter: true,
        link: compliances_path
      }
    end

    def member_engagement
      {
        title: 'Member Engagement',
        count: 0,
        show_counter: false,
        link: users_path
      }
    end

    def chronic_condition_management_dashboard
      {
        title: 'Chronic Management Dashboard',
        count: 0,
        show_counter: false,
        link: chronic_condition_managements_path
      }
    end
  end
end
