# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  
  layout 'campaign'
  before_action :set_header
  before_action :set_announcement, only: %i[show edit update destroy launch review]
  before_action -> { set_members_hash(@announcement) }, only:  %i[new edit]
  load_and_authorize_resource

  def index
    @records_with_categories = Announcement.select(:announcement_category).group(:announcement_category).count

    @announcements = Announcement.search(params).order(created_at: :desc)
    @user_actions_count = Announcement.joins(:user_actions).order(created_at: :desc).group(:id).count

    respond_to do |format|
      format.html do
        @announcements =  @announcements.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @announcements =  @announcements.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json:  @announcements
      end
    end
    render layout: 'admin'
  end

  def show
    @user_actions = UserAction.search(params)
    set_charts_data(@announcement)
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
      announcement = Announcement.find(params[:goal_id])
      @announcement = announcement.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @announcement = custom_template.duplicate_with_assn(params)
      @announcement.member_selections.build
    elsif params[:by_goal].present?
      @announcement = Announcement.new
      @announcement.milestones.build.action_steps.build
      @announcement.member_selections.where(
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
      ).build
    else
      @announcement = Announcement.new
      # @announcement.member_selections.build
      @announcement.member_selections.build
      @announcement.milestones.build.action_steps.build
    end
  end

  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.status = 'Draft'
    @announcement.owner_id = current_user.id

    respond_to do |format|
      if @announcement.save
        format.html do
          redirect_to redirect_path(controller_name, @announcement), notice: 'announcement was successfully created.'
        end
        format.js
        format.json { render :edit, status: :created, location: @announcement }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end

  def launch
    @user_actions_count = @announcement.user_actions_count
    respond_to do |format|
      if @announcement.can_launch? && @announcement.update(status: 'Active')
        format.html
        format.js
      else
        format.html { redirect_to review_announcement_path(@announcement), status: :unprocessable_entity }
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /announcements/1 or /announcements/1.json
  def update
    update_announcement_params = announcement_params.merge(status: 'Draft')
    respond_to do |format|
      if @announcement.update(update_announcement_params)
        format.html do
          redirect_to redirect_path(controller_name, @announcement), notice: 'announcement was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1 or /announcements/1.json
  def destroy
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to announcements_url, notice: 'announcement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def announcement_params
    params.require(:announcement).permit(
      :section, :name, :announcement_type, :announcement_category, :status,
      :start_date, :end_date, :criteria_type, :criterial_value, :description, :icon, :save_to_draft, :goal_id, :template_id,
      milestones_attributes: [
        :id, :_destroy, { action_steps_attributes: %i[
          id step_number name interaction message action artifact_type
          artifact_text artifact_url artifact_video artifact_document _destroy
        ] }
      ],
      member_selections_attributes: %i[
        id criteria_type criteria_sub_type criterial_value
        criterial_start_range criterial_end_range unit link_to_id link_to_type milestone_id status _destroy
      ]
    )
  end

  def set_header
    @header = 'Launch New Announcement'
  end
end
