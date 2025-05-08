# frozen_string_literal: true

class TimelyRecoveryGoalsController < ApplicationController
  
  layout 'campaign'
  before_action :set_header
  before_action :set_timely_recovery_goal, only: %i[show edit update destroy review launch]

  # GET /timely_recovery_goals or /timely_recovery_goals.json
  def index
    @records_with_categories = TimelyRecoveryGoal.select(:timely_recovery_goal_category).group(:timely_recovery_goal_category).count
    @timely_recovery_goals = TimelyRecoveryGoal.search(params).order(created_at: :desc)
    @user_actions_count = TimelyRecoveryGoal.joins(:user_actions).order(created_at: :desc).group(:id).count

    respond_to do |format|
      format.html do
        @timely_recovery_goals =  @timely_recovery_goals.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @timely_recovery_goals =  @timely_recovery_goals.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json:  @timely_recovery_goals
      end
    end
    render layout: 'admin'
  end

  # GET /timely_recovery_goals/1 or /timely_recovery_goals/1.json
  def show
    set_charts_data(@timely_recovery_goal)
    @user_actions = UserAction.eager_load(:user, :user_action_steps).where(actionable_id: @timely_recovery_goal.id,
                                                                           actionable_type: 'TimelyRecoveryGoal')
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

  # GET /timely_recovery_goals/new
  def new
    if params[:goal_id].present?
      timely_recovery_goal = TimelyRecoveryGoal.find(params[:goal_id])
      @timely_recovery_goal = timely_recovery_goal.duplicate_with_assn(params)
    else
      @timely_recovery_goal = TimelyRecoveryGoal.new
      # @timely_recovery_goal.action_steps.build
      @timely_recovery_goal.milestones.build.action_steps.build
    end
  end

  # GET /timely_recovery_goals/1/edit
  def edit; end

  # POST /timely_recovery_goals or /timely_recovery_goals.json
  def create
    @timely_recovery_goal = TimelyRecoveryGoal.new(timely_recovery_goal_params)
    @timely_recovery_goal.owner_id = current_user.id
    respond_to do |format|
      if @timely_recovery_goal.save
        format.html do
          redirect_to review_timely_recovery_goal_url(@timely_recovery_goal),
                      notice: 'Timely Intervention Goal was successfully created.'
        end
        format.json { render :show, status: :created, location: @timely_recovery_goal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @timely_recovery_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  def launch
    @user_actions_count = @timely_recovery_goal.user_actions.count
    respond_to do |format|
      if @timely_recovery_goal.update(status: 'Active')
        format.html
        format.js
      else
        format.html do
          redirect_to review_timely_recovery_goal_path(@timely_recovery_goal), status: :unprocessable_entity
        end
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /timely_recovery_goals/1 or /timely_recovery_goals/1.json
  def update
    update_timely_recovery_goal_params = timely_recovery_goal_params
    respond_to do |format|
      if @timely_recovery_goal.update(update_timely_recovery_goal_params)
        format.html do
          redirect_to review_timely_recovery_goal_url(@timely_recovery_goal),
                      notice: 'timely_recovery_goal was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @timely_recovery_goal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @timely_recovery_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timely_recovery_goals/1 or /timely_recovery_goals/1.json
  def destroy
    @timely_recovery_goal.destroy

    respond_to do |format|
      format.html { redirect_to timely_recovery_goals_url, notice: 'Timely recovery goal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_timely_recovery_goal
    @timely_recovery_goal = TimelyRecoveryGoal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def timely_recovery_goal_params
    params.require(:timely_recovery_goal).permit(
      :section, :name, :timely_recovery_goal_type, :timely_recovery_goal_category, :status,
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
    @header = 'New Quality Improvement Timely Intervention Goal'
  end
end
