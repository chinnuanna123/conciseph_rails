# frozen_string_literal: true

class ChronicConditionManagementsController < ApplicationController
  before_action :set_hash
  before_action :set_header
  layout 'admin'
  def index
    @data = Chart::ChronicChartData.new.call
    @users = User.all.includes(:user_actions, :medications).order(created_at: :desc)
    respond_to do |format|
      format.html do
        @users = @users.paginate(page: params[:page], per_page: 10)

        @user_actions_medication_adherence = @user_actions_hash[:medication_adherence].paginate(page: params[:page],
                                                                                                per_page: 10)
      end
    end
  end

  def medication_adherence
    respond_to do |format|
      format.html do
        @user_actions_medication_adherence = @user_actions_hash[:medication_adherence].paginate(page: params[:page],
                                                                                                per_page: 10)
      end
    end
  end

  def medication_refills
    respond_to do |format|
      format.html do
        @user_actions_medication_refill_adherence = @user_actions_hash[:medication_refill_adherence].paginate(
          page: params[:page], per_page: 10
        )
      end
    end
    @header = 'Medication Refill Requests'
  end

  def health_education
    respond_to do |format|
      format.html do
        @user_actions_health_education = @user_actions_hash[:health_education_data].paginate(page: params[:page],
                                                                                             per_page: 10)
      end
    end
  end

  def nutrition_therapy
    respond_to do |format|
      format.html do
        @user_actions_nutrition_therapy = @user_actions_hash[:nutrition_therapy_completeness_data].paginate(
          page: params[:page], per_page: 10
        )
      end
    end
  end

  def health_events
    respond_to do |format|
      format.html do
        @user_actions_health_event = @user_actions_hash[:health_event_data].paginate(page: params[:page], per_page: 10)
      end
    end
  end

  def feedbacks
    respond_to do |format|
      format.html do
        @user_actions_member_feedback = @user_actions_hash[:member_feedback_data].paginate(page: params[:page],
                                                                                           per_page: 10)
      end
    end
  end

  def hb1ac
    @user_actions_hbac = @user_actions_hash[:hbac].paginate(page: params[:page], per_page: 10)
    @header = 'Hb1AC'
  end

  def schedule_adherence
    @user_actions_schedule_adherence = @user_actions_hash[:schedule_adherence].paginate(page: params[:page],
                                                                                        per_page: 10)
    @header = 'Medication Non Adherence Members'
  end

  def set_hash
    @user_actions_hash = Chart::ChronicChartData.new(listing = true).call
  end

  def set_header
    @header = action_name.titleize
  end
end
