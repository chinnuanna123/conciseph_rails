# frozen_string_literal: true

class HealthEventsController < ApplicationController
  
  layout 'campaign'
  before_action :set_header
  before_action :set_health_event, only: %i[show edit update destroy launch review]
  before_action -> { set_members_hash(@health_event) }, only:  %i[new edit]

  def index
    @records_with_categories = HealthEvent.select(:health_event_category).group(:health_event_category).count
    @health_events = HealthEvent.search(params).order(created_at: :desc)
    @user_actions_count = HealthEvent.joins(:user_actions).order(created_at: :desc).group(:id).count
    respond_to do |format|
      format.html do
        @health_events = @health_events.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @health_events = @health_events.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @health_events
      end
    end
    render layout: 'admin'
  end

  def show
    @user_actions = UserAction.search(params)
     set_charts_data(@health_event)
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
      health_event = HealthEvent.find(params[:goal_id])
      @health_event = health_event.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @health_event = custom_template.duplicate_with_assn(params)
      @health_event.member_selections.build
    elsif params[:by_goal].present?
      @health_event = HealthEvent.new
      @health_event.milestones.build.action_steps.build
      @health_event.member_selections.where(
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
      ).build
    else
      @health_event = HealthEvent.new
      # @health_event.action_steps.build
      @health_event.member_selections.build
      @health_event.milestones.build.action_steps.build
    end
  end

  def create
    @health_event = HealthEvent.new(health_event_params)
    @health_event.status = 'Draft'
    @health_event.owner_id = current_user.id

    respond_to do |format|
      if @health_event.save
        format.html do
          redirect_to redirect_path(controller_name, @health_event), notice: 'health_event was successfully created.'
        end
        format.js
        format.json { render :edit, status: :created, location: @health_event }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @health_event.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end

  def launch
    @user_actions_count = @health_event.user_actions_count
    respond_to do |format|
      if @health_event.can_launch? && @health_event.update(status: 'Active')
        format.html
        format.js
      else
        format.html { redirect_to redirect_path(controller_name, @health_event), status: :unprocessable_entity }
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /health_events/1 or /health_events/1.json
  def update
    update_health_event_params = health_event_params.merge(status: 'Draft')
    respond_to do |format|
      if @health_event.update(update_health_event_params)
        format.html do
          redirect_to redirect_path(controller_name, @health_event), notice: 'health_event was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @health_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @health_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /health_events/1 or /health_events/1.json
  def destroy
    @health_event.destroy

    respond_to do |format|
      format.html { redirect_to health_events_url, notice: 'health_event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_health_event
    @health_event = HealthEvent.find(params[:id])
  end

  def health_event_params
    params.require(:health_event).permit(
      :section, :name, :health_event_type, :health_event_category, :status,
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
    @header = 'New Health Event'
  end
end
