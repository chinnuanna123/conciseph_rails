# frozen_string_literal: true

module UserActions
  class CreateService
    attr_reader :actionable, :members, :actionable_type, :actionable_id, :counter, :user, :user_action

    def initialize(actionable, counter: false, user: nil, params: nil, current_user: nil)
      @actionable = actionable # object ==> goal or announcement
      @actionable_type = actionable.class.to_s
      @actionable_id = actionable.id
      @current_user = current_user || User.find(actionable.owner_id)
      @members =  if user.present?
                    [user]
                  elsif params.present? && params[:link_to_id].present?
                    set_users_by_params(params)
                  elsif params.present? && params[:data].present?
                    set_users_by_ajax(JSON.parse(params[:data]))
                  else
                    fetch_members
                  end
      @counter = counter
      @user = user
    end

    def call
      return false if actionable.nil? || members.blank?
      return members.count if counter == true

      members.each do |member|
        build_user_action(member)
        next if user_action.blank? 

        build_user_action_milestones
        user_action.save!
        # SendFcmMessagesJob.perform_later(user_action)
      end
    end

    # private

    def build_user_action(member)
      @user_action = member.user_actions.where(actionable_id: actionable_id,
                                actionable_type: actionable_type).first_or_initialize
    end

    def build_user_action_milestones
      existing_action_milestones = user_action.user_action_milestones.pluck(:milestone_id)
      actionable.milestones.each do |milestone|
        next if existing_action_milestones.include?(milestone.id)

        user_action.user_action_milestones.build(milestone_id: milestone.id)
      end
    end


    def fetch_members
      member_selections = actionable.member_selections
      if member_selections.last.link_to_id.present?
        milestone_id, link_to_type, link_to_id, status = actionable.member_selections.pluck(:milestone_id,
                                                                                            :link_to_type, :link_to_id, :milestone_status).first
        return milestone_users_query(milestone_id, link_to_type, link_to_id, status)
      end
      query = []
      search_obj = {}
      member_selections.each_with_index do |criteria, index|
        next if criteria.criteria_type.nil?

        case criteria.criteria_type
        when 'Gender', 'Ethnicity', 'Speciality'
          query << "users.#{criteria.criteria_type.downcase} = :criterial_value_#{index + 1}"
          search_obj["criterial_value_#{index + 1}".to_sym] =
            User.send(criteria.criteria_type.downcase.pluralize)[criteria.criterial_value]
        when 'Age'
          sub_query, sub_search_obj = if criteria.criteria_sub_type == 'Range'
                                        age_query(criteria.criteria_sub_type, "#{criteria.criterial_start_range}-#{criteria.criterial_end_range}",
                                                  criteria.unit, index + 1)
                                      else
                                        age_query(criteria.criteria_sub_type, criteria.criterial_value.to_i,
                                                  criteria.unit, index + 1)
                                      end
          query << sub_query
          search_obj.merge!(sub_search_obj)
        when 'Zip Code'
          zip_query = "users.#{criteria.criteria_type.parameterize.underscore} = :criterial_value_#{index + 1}"
          zip_search_obj = {}
          zip_search_obj["criterial_value_#{index + 1}".to_sym] = criteria.criterial_value
          query << zip_query
          search_obj.merge!(zip_search_obj)
        when 'All Members'
          # do nothing
        end
      end
      User.where(query.join(' AND '), search_obj)
          .where('is_admin = ? and super_admin = ? and otp_verified= ? and referred_by = ?', false, false, true, @current_user.refer.code).order('users.created_at DESC')
    end

    # Find users with age equal to 3 years
    # age_query('Is equal to', 3, 'years', index)

    # Find users with age greater than 18 months
    # age_query('Greater Than', 18, 'months', index)

    # Find users with age in the range of 4 to 6 years
    # age_query('Range', '4-6', 'years', index)

    def age_query(type, value, unit, index)
      age_in_years = 'users.reporting_age + EXTRACT(YEAR FROM AGE(users.age_updated_at))'
      age_in_months = "#{age_in_years} * 12 + EXTRACT(MONTH FROM AGE(age_updated_at))"
      if unit == 'years' || unit.nil?
        age_placeholder = age_in_years
      elsif unit == 'months'
        age_placeholder = age_in_months
      end

      search_obj = {}
      query, search_obj = case type
                          when 'Is equal to'
                            ["#{age_placeholder} = :value_#{index}", { "value_#{index}".to_sym => value.to_i }]
                          when 'Greater Than'
                            ["#{age_placeholder} > :value_#{index}", { "value_#{index}".to_sym => value.to_i }]
                          when 'Less Than'
                            ["#{age_placeholder} < :value_#{index}", { "value_#{index}".to_sym => value.to_i }]
                          when 'Not Less Than'
                            ["#{age_placeholder} >= :value_#{index}", { "value_#{index}".to_sym => value.to_i }]
                          when 'Not Greater Than'
                            ["#{age_placeholder} <= :value_#{index}", { "value_#{index}".to_sym => value.to_i }]
                          when 'Range'
                            start_age, end_age = value.split('-').map(&:to_i)
                            ["#{age_placeholder} BETWEEN :start_age_#{index} AND :end_age_#{index}",
                             { "start_age_#{index}".to_sym => start_age, "end_age_#{index}".to_sym => end_age }]
                          else
                            raise ArgumentError, "Unsupported type: #{type}"
                          end
    end

    def milestone_users_query(milestone_id, link_to_type, link_to_id, status)
      user_actions = UserAction.where(actionable_id: link_to_id, actionable_type: link_to_type)
      user_ids_arr = UserAction.left_joins(:user_action_milestones).where(actionable_id: link_to_id, actionable_type: link_to_type).where(
        'user_action_milestones.status = :status AND  user_action_milestones.milestone_id = :milestone_id ', { status: status,
                                                                                                               milestone_id: milestone_id }
      ).pluck(:user_id)
      

      User.where(id: user_ids_arr)
    end

    def set_users_by_params(params)
      milestone_id = params[:milestone_id]
      link_to_id = params[:link_to_id]
      link_to_type = params[:link_to_type]
      milestone_status = params[:milestone_status].to_i
      milestone_users_query(milestone_id, link_to_type, link_to_id, milestone_status)
    end

    def set_users_by_ajax(member_selection_arr)
      # array of hashes
      query = []
      search_obj = {}
      member_selection_arr.each_with_index do |criteria, index|
        criteria_type = criteria['criteria_type']
        criteria_val = criteria['criteria_val']
        next if criteria_type.nil? || criteria_val.nil?

          case criteria_type
            when 'Gender', 'Ethnicity', 'Specialty'
              # binding.pry
              query << "users.#{criteria_type.downcase} = :criterial_value_#{index + 1}"
              search_obj["criterial_value_#{index + 1}".to_sym] = User.send(criteria_type.downcase.pluralize)[criteria_val]
            when 'Age'
              from = criteria['from']
              to = criteria['to']
              unit = criteria['unit']
              age_value = criteria['age_value']
              sub_query, sub_search_obj = if criteria_val == 'Range'
                                            age_query(criteria_val, "#{from}-#{to}",
                                                      unit, index + 1)
                                          else
                                            age_query(criteria_val, age_value.to_i,
                                                      unit, index + 1)
                                          end
              query << sub_query
              search_obj.merge!(sub_search_obj)
            when 'Zip Code'
              zip_query = "users.#{criteria_type.parameterize.underscore} = :criterial_value_#{index + 1}"
              zip_search_obj = {}
              zip_search_obj["criterial_value_#{index + 1}".to_sym] = criteria_val
              query << zip_query
              search_obj.merge!(zip_search_obj)
            when 'All Members'
              # do nothing
          end
        end
        User.where(query.join(' AND '), search_obj).where('is_admin = ? and super_admin = ? and otp_verified= ? and referred_by = ?', false, false, true, @current_user.refer.code).order('users.created_at DESC')
    end
  end
end
