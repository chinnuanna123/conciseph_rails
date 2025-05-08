# frozen_string_literal: true

module UserActions
  class FetchListingService
    attr_reader :params, :page, :per_page, :user, :action_name

    def initialize(params, user, action_name)
      @params = params
      @user = user
      @page = params[:page_no].present? ? params[:page_no].to_i : 1
      @per_page = 20
      @action_name = action_name
    end

    def call
      return [] if action_plans.blank?

      action_plans
    end

    private

    def action_plans
      @action_plans ||= case action_name
                      when 'action_plans'
                        fetch_action_plans
                      when 'announcements'
                        user_announcements
                      when 'feedbacks'
                        user_feedbacks
                      else
                        []
                      end
    end

    def user_feedbacks
      section = MemberFeedback.sections[params[:section]]
      compliance_section = MemberFeedback.sections[params[:section]]

      user_specific_actions
        .joins(join_query('MemberFeedback'))
        .joins(join_query('Compliance'))
        .where('(member_feedbacks.section = :section OR compliances.section = :compliance_section)', {
                 section: section, compliance_section: compliance_section
               })
               .page(page).per_page(per_page).order(created_at: :desc)
    end

    def user_announcements
      section = Announcement.sections[params[:section]]

      user_specific_actions
        .joins(join_query('Announcement'))
        .where('(announcements.section = :section)', section: section)
        .page(page).per_page(per_page).order(created_at: :desc)
    end

    def fetch_action_plans
      case params[:section]
      when 'Timely Recovery'
        timely_recovery_actions
      when 'Better Health'
        better_health_actions
      else
        []
      end
    end

    def better_health_actions
      user_specific_actions
        .joins(join_query('Goal'))
        .joins(join_query('HealthEducation'))
        .joins(join_query('HealthEvent'))
        .where('(goals.section = :section OR health_educations.section = :section
            OR health_events.section = :section)', section: 0)
            .page(page).per_page(per_page).order(created_at: :desc)
    end

    def timely_recovery_actions
      user_specific_actions
        .joins(join_query('TimelyRecoveryGoal'))
        .where('(timely_recovery_goals.section = :section)', section: 0)
        .page(page).per_page(per_page).order(created_at: :desc)
    end

    def user_specific_actions
      UserAction.includes(actionable: :icon_attachment).where(user_id: @user.id)
    end

    def join_query(model_name)
      table_name = model_name.pluralize.underscore
      "LEFT JOIN #{table_name} ON user_actions.actionable_id = #{table_name}.id
      AND user_actions.actionable_type = '#{model_name}'"
    end
  end
end
