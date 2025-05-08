# frozen_string_literal: true

class MemberFeedbacksController < ApplicationController
  
  layout 'campaign'
  before_action :set_header
  before_action :set_member_feedback, only: %i[show edit update destroy launch review]
  before_action -> { set_members_hash(@member_feedback) }, only:  %i[new edit]

  def index
    @records_with_categories = MemberFeedback.select(:member_feedback_category).group(:member_feedback_category).count
    @member_feedbacks = MemberFeedback.search(params).order(created_at: :desc)
    @user_actions_count = MemberFeedback.joins(:user_actions).order(created_at: :desc).group(:id).count
    respond_to do |format|
      format.html do
        @member_feedbacks = @member_feedbacks.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @member_feedbacks = @member_feedbacks.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @member_feedbacks
      end
    end
    render layout: 'admin'
  end

  def show
    @user_actions = UserAction.search(params)
     set_charts_data(@member_feedback)
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
      member_feedback = MemberFeedback.find(params[:goal_id])
      @member_feedback = member_feedback.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @member_feedback = custom_template.duplicate_with_assn(params)
      @member_feedback.member_selections.build
    elsif params[:by_goal].present?
      @member_feedback = MemberFeedback.new
      @member_feedback.milestones.build.action_steps.build
      @member_feedback.member_selections.where(
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
      ).build
    else
      @member_feedback = MemberFeedback.new
      # @member_feedback.action_steps.build
      @member_feedback.member_selections.build
      @member_feedback.milestones.build.action_steps.build
    end
  end

  def create
    @member_feedback = MemberFeedback.new(member_feedback_params)
    @member_feedback.status = 'Draft'
    @member_feedback.owner_id = current_user.id

    respond_to do |format|
      if @member_feedback.save
        format.html do
          redirect_to review_member_feedback_path(@member_feedback), notice: 'member_feedback was successfully created.'
        end
        format.js
        format.json { render :edit, status: :created, location: @member_feedback }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member_feedback.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end

  def launch
    @user_actions_count = @member_feedback.user_actions_count
    respond_to do |format|
      if @member_feedback.can_launch? && @member_feedback.update(status: 'Active')
        format.html
        format.js
      else
        format.html { redirect_to review_member_feedback_path(@member_feedback), status: :unprocessable_entity }
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /member_feedbacks/1 or /member_feedbacks/1.json
  def update
    update_member_feedback_params = member_feedback_params.merge(status: 'Draft')
    respond_to do |format|
      if @member_feedback.update(update_member_feedback_params)
        format.html do
          redirect_to review_member_feedback_url(@member_feedback), notice: 'member_feedback was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @member_feedback }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member_feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_feedbacks/1 or /member_feedbacks/1.json
  def destroy
    @member_feedback.destroy

    respond_to do |format|
      format.html { redirect_to member_feedbacks_url, notice: 'member_feedback was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_member_feedback
    @member_feedback = MemberFeedback.find(params[:id])
  end

  def member_feedback_params
    params.require(:member_feedback).permit(
      :section, :name, :member_feedback_type, :member_feedback_category, :status,
      :start_date, :end_date, :criteria_type, :criterial_value, :description, :icon, :goal_id, :template_id,
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
    @header = 'New Feedback / Survey'
  end
end
