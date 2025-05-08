# frozen_string_literal: true

class HealthEducationsController < ApplicationController
  
  layout 'campaign'
  before_action :set_header
  before_action :set_health_education, only: %i[show edit update destroy launch review]
  before_action -> { set_members_hash(@health_education) }, only:  %i[new edit]

  def index
    @records_with_categories = HealthEducation.select(:health_education_category).group(:health_education_category).count
    @health_educations = HealthEducation.search(params).order(created_at: :desc)
    @user_actions_count = HealthEducation.joins(:user_actions).order(created_at: :desc).group(:id).count
    respond_to do |format|
      format.html do
        @health_educations = @health_educations.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @health_educations = @health_educations.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @health_educations
      end
    end
    render layout: 'admin'
  end

  def show
    @user_actions = UserAction.search(params)
     set_charts_data(@health_education)
    respond_to do |format|
      format.html do
        @user_actions = @user_actions.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @user_actions = @user_actions.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @user_actions
      end
    end
    render layout: 'admin'
  end

  def edit; end

  def new
    if params[:goal_id].present?
      health_education = HealthEducation.find(params[:goal_id])
      @health_education = health_education.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @health_education = custom_template.duplicate_with_assn(params)
      @health_education.member_selections.build
    elsif params[:by_goal].present?
      @health_education = HealthEducation.new
      @health_education.milestones.build.action_steps.build
      @health_education.member_selections.where(
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
      ).build
    else
      @health_education = HealthEducation.new
      # @health_education.action_steps.build
      @health_education.member_selections.build
      @health_education.milestones.build.action_steps.build
    end
  end

  def create
    @health_education = HealthEducation.new(health_education_params)
    @health_education.status = 'Draft'
    @health_education.owner_id = current_user.id

    respond_to do |format|
      if @health_education.save
        format.html do
          redirect_to redirect_path(controller_name, @health_education),
                      notice: 'health_education was successfully created.'
        end
        format.js
        format.json { render :edit, status: :created, location: @health_education }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @health_education.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end

  def launch
    @user_actions_count = @health_education.user_actions_count
    respond_to do |format|
      if @health_education.can_launch? && @health_education.update(status: 'Active')
        format.html
        format.js
      else
        format.html { redirect_to review_health_education_path(@health_education), status: :unprocessable_entity }
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /health_educations/1 or /health_educations/1.json
  def update
    update_health_education_params = health_education_params.merge(status: 'Draft')
    respond_to do |format|
      if @health_education.update(update_health_education_params)
        format.html do
          redirect_to redirect_path(controller_name, @health_education),
                      notice: 'health_education was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @health_education }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @health_education.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /health_educations/1 or /health_educations/1.json
  def destroy
    @health_education.destroy

    respond_to do |format|
      format.html { redirect_to health_educations_url, notice: 'health_education was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_health_education
    @health_education = HealthEducation.find(params[:id])
  end

  def health_education_params
    params.require(:health_education).permit(
      :section, :name, :health_education_type, :health_education_category, :status,
      :start_date, :end_date, :criteria_type, :criterial_value, :description, :icon, :save_to_draft, :goal_id, :template_id,
      milestones_attributes: [
        :id, :_destroy, { action_steps_attributes: %i[
          id step_number name interaction message action artifact_type
          artifact_text artifact_url artifact_video artifact_document _destroy
        ] }
      ],
      member_selections_attributes: %i[
        id criteria_type criteria_sub_type criterial_value
        criterial_start_range criterial_end_range unit link_to_id link_to_type milestone_status milestone_id _destroy
      ]
    )
  end

  def set_header
    @header = 'New Health Education Goal'
  end
end
