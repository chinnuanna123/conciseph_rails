# frozen_string_literal: true

class ChronicConditionManagementGoalsController < ApplicationController
  
  before_action :check_super_admin
  layout 'campaign'
  before_action :set_header
  before_action :set_chronic_condition_management_goal, only: %i[show edit update destroy launch review]
  before_action -> { set_members_hash(@chronic_condition_management_goal) }, only:  %i[new edit]
  load_and_authorize_resource

  # GET /chronic_condition_management_goals or /chronic_condition_management_goals.json
  def index
    @records_with_categories = ChronicConditionManagementGoal.select(:chronic_condition_management_goal_category).group(:chronic_condition_management_goal_category).count
    @chronic_condition_management_goals = ChronicConditionManagementGoal.search(params).order(created_at: :desc)
    @user_actions_count = ChronicConditionManagementGoal.joins(:user_actions).order(created_at: :desc).group(:id).count

    respond_to do |format|
      format.html do
        @chronic_condition_management_goals = @chronic_condition_management_goals.paginate(page: params[:page],
                                                                                           per_page: 10)
      end
      format.js do
        @chronic_condition_management_goals = @chronic_condition_management_goals.paginate(page: params[:page],
                                                                                           per_page: 10)
      end
      format.json do
        render json: @chronic_condition_management_goals
      end
    end
    render layout: 'admin'
  end

  # GET /chronic_condition_management_goals/1 or /chronic_condition_management_goals/1.json
  def show
    @user_actions = UserAction.search(params)
     set_charts_data(@chronic_condition_management_goal)
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

  # GET /chronic_condition_management_goals/new
  def new
    if params[:goal_id].present?
      chronic_condition_management_goal = ChronicConditionManagementGoal.find(params[:goal_id])
      @chronic_condition_management_goal = chronic_condition_management_goal.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @chronic_condition_management_goal = custom_template.duplicate_with_assn(params)
      @chronic_condition_management_goal.member_selections.build
    else
      @chronic_condition_management_goal = ChronicConditionManagementGoal.new
      # @chronic_condition_management_goal.action_steps.build
      @chronic_condition_management_goal.member_selections.build
      @chronic_condition_management_goal.milestones.build.action_steps.build
    end
  end

  # GET /chronic_condition_management_goals/1/edit
  def edit; end

  # POST /chronic_condition_management_goals or /chronic_condition_management_goals.json
  def create
    @chronic_condition_management_goal = ChronicConditionManagementGoal.new(chronic_condition_management_goal_params)
    @chronic_condition_management_goal.status = 'Draft'
    @chronic_condition_management_goal.owner_id = current_user.id

    respond_to do |format|
      if @chronic_condition_management_goal.save
        # redirect_path = send("#{controller_name.singularize}_params")[:save_to_draft] == 'true' ? send("#{controller_name}_path") : send("review_#{controller_name.singularize}_path", @chronic_condition_management_goal)

        format.html do
          redirect_to redirect_path(controller_name, @chronic_condition_management_goal),
                      notice: 'chronic_condition_management_goal was successfully created.'
        end
        format.js
        format.json { render :edit, status: :created, location: @chronic_condition_management_goal }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chronic_condition_management_goal.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end
  # launch

  def launch
    # TODO: sachin- create one instance method in chronic_condition_management_goal (def can_lanch_chronic_condition_management_goal?) and this date logic over there
    # @user_chronic_condition_management_goals_count = @chronic_condition_management_goal.user_chronic_condition_management_goals.count
    @user_actions_count = @chronic_condition_management_goal.user_actions_count
    respond_to do |format|
      if @chronic_condition_management_goal.can_launch? && @chronic_condition_management_goal.update(status: 'Active')
        format.html
        format.js
      else
        format.html do
          redirect_to review_chronic_condition_management_goal_path(@chronic_condition_management_goal),
                      status: :unprocessable_entity
        end
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /chronic_condition_management_goals/1 or /chronic_condition_management_goals/1.json
  def update
    update_chronic_condition_management_goal_params = chronic_condition_management_goal_params.merge(status: 'Draft')
    respond_to do |format|
      if @chronic_condition_management_goal.update(update_chronic_condition_management_goal_params)
        format.html do
          redirect_to redirect_path(controller_name, @chronic_condition_management_goal),
                      notice: 'chronic_condition_management_goal was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @chronic_condition_management_goal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chronic_condition_management_goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chronic_condition_management_goals/1 or /chronic_condition_management_goals/1.json
  def destroy
    @chronic_condition_management_goal.destroy

    respond_to do |format|
      format.html do
        redirect_to chronic_condition_management_goals_url,
                    notice: 'chronic_condition_management_goal was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chronic_condition_management_goal
    @chronic_condition_management_goal = ChronicConditionManagementGoal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def chronic_condition_management_goal_params
    params.require(:chronic_condition_management_goal).permit(
      :section, :name, :chronic_condition_management_goal_type, :chronic_condition_management_goal_category, :status,
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
      ],
      new_chronic_condition_management_goal_action_steps: %i[
        id step_number name interaction artifact_type artifact_text
        artifact_url artifact_video _destroy
      ]
    )
  end

  def set_header
    @header = 'Chronic Condition Management Goal'
  end
end
