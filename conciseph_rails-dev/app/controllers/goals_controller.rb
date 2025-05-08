# frozen_string_literal: true

class GoalsController < ApplicationController
  
  before_action :check_super_admin
  layout 'campaign'
  before_action :set_header
  before_action :set_goal, only: %i[show edit update destroy launch review]
  before_action -> { set_members_hash(@goal) }, only:  %i[new edit]
  load_and_authorize_resource

  # GET /goals or /goals.json
  def index
    @records_with_categories = Goal.select(:goal_category).group(:goal_category).count
    @goals = Goal.search(params).order(created_at: :desc)
    @user_actions_count = Goal.joins(:user_actions).order(created_at: :desc).group(:id).count

    respond_to do |format|
      format.html do
        @goals = @goals.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @goals = @goals.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @goals
      end
    end
    render layout: 'admin'
  end

  # GET /goals/1 or /goals/1.json
  def show
    # @user_actions = UserAction.search(params)
    set_charts_data(@goal)

    @user_actions = UserAction.search(params)
    # @user_actions = UserAction.includes(:user, user_action_milestones: :user_action_steps).where(actionable_id: params[:id], actionable_type: 'Goal')
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

  # GET /goals/new
  def new
    if params[:goal_id].present?
      goal = Goal.find(params[:goal_id])
      @goal = goal.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @goal = custom_template.duplicate_with_assn(params)
      @goal.member_selections.build
    elsif params[:by_goal].present?
      @goal = Goal.new
      @goal.milestones.build.action_steps.build
      @goal.member_selections.where(
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
      ).build
    else
      @goal = Goal.new
      # @goal.action_steps.build
      @goal.member_selections.build
      @goal.milestones.build.action_steps.build
    end
  end

  # GET /goals/1/edit
  def edit; end

  # POST /goals or /goals.json
  def create
    @goal = Goal.new(goal_params)
    @goal.status = 'Draft'
    @goal.owner_id = current_user.id

    respond_to do |format|
      if @goal.save
        # redirect_path = send("#{controller_name.singularize}_params")[:save_to_draft] == 'true' ? send("#{controller_name}_path") : send("review_#{controller_name.singularize}_path", @goal)

        format.html { redirect_to redirect_path(controller_name, @goal), notice: 'Goal was successfully created.' }
        format.js
        format.json { render :edit, status: :created, location: @goal }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end
  # launch

  def launch
    # TODO: sachin- create one instance method in goal (def can_lanch_goal?) and this date logic over there
    # @user_goals_count = @goal.user_goals.count
    @user_actions_count = @goal.user_actions_count
    respond_to do |format|
      if @goal.can_launch? && @goal.update(status: 'Active')
        format.html
        format.js
      else
        format.html { redirect_to review_goal_path(@goal), status: :unprocessable_entity }
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /goals/1 or /goals/1.json
  def update
    update_goal_params = goal_params.merge(status: 'Draft')
    respond_to do |format|
      if @goal.update(update_goal_params)
        format.html { redirect_to redirect_path(controller_name, @goal), notice: 'Goal was successfully updated.' }
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1 or /goals/1.json
  def destroy
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to goals_url, notice: 'Goal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_goal
    @goal = Goal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def goal_params
    params.require(:goal).permit(
      :section, :name, :goal_type, :goal_category, :status,
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
      new_goal_action_steps: %i[
        id step_number name interaction artifact_type artifact_text
        artifact_url artifact_video _destroy
      ]
    )
  end

  def set_header
    @header = 'New Quality Measures Goal'
  end
end
