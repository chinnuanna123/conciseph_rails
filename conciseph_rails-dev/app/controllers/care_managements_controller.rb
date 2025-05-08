# frozen_string_literal: true

class CareManagementsController < ApplicationController
  
  before_action :check_super_admin
  layout 'campaign'
  before_action :set_header
  before_action :set_care_management, only: %i[show edit update destroy launch review]
  before_action :set_members_hash, only: %i[new edit]
  load_and_authorize_resource

  # GET /care_managements or /care_managements.json
  def index
    @records_with_categories = CareManagement.select(:care_management_category).group(:care_management_category).count
    @care_managements = CareManagement.search(params).order(created_at: :desc)
    @user_actions_count = CareManagement.joins(:user_actions).order(created_at: :desc).group(:id).count

    respond_to do |format|
      format.html do
        @care_managements = @care_managements.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @care_managements = @care_managements.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @care_managements
      end
    end
    render layout: 'admin'
  end

  # GET /care_managements/1 or /care_managements/1.json
  def show
    @user_actions = UserAction.search(params)
     set_charts_data(@care_management)
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

  # GET /care_managements/new
  def new
    if params[:care_management_id].present?
      care_management = CareManagement.find(params[:goal_id])
      @care_management = care_management.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @care_management = custom_template.duplicate_with_assn(params)
      @care_management.member_selections.build
    else
      @care_management = CareManagement.new
      # @care_management.action_steps.build
      @care_management.member_selections.build
      @care_management.milestones.build.action_steps.build
    end
  end

  # GET /care_managements/1/edit
  def edit; end

  # POST /care_managements or /care_managements.json
  def create
    @care_management = CareManagement.new(care_management_params)
    @care_management.status = 'Draft'
    @care_management.owner_id = current_user.id

    respond_to do |format|
      if @care_management.save
        # redirect_path = send("#{controller_name.singularize}_params")[:save_to_draft] == 'true' ? send("#{controller_name}_path") : send("review_#{controller_name.singularize}_path", @care_management)

        format.html do
          redirect_to redirect_path(controller_name, @care_management),
                      notice: 'care_management was successfully created.'
        end
        format.js
        format.json { render :edit, status: :created, location: @care_management }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @care_management.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end
  # launch

  def launch
    # TODO: sachin- create one instance method in care_management (def can_lanch_care_management?) and this date logic over there
    # @user_care_managements_count = @care_management.user_care_managements.count
    @user_actions_count = @care_management.user_actions_count
    respond_to do |format|
      if @care_management.can_launch? && @care_management.update(status: 'Active')
        format.html
        format.js
      else
        format.html { redirect_to review_care_management_path(@care_management), status: :unprocessable_entity }
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /care_managements/1 or /care_managements/1.json
  def update
    update_care_management_params = care_management_params.merge(status: 'Draft')
    respond_to do |format|
      if @care_management.update(update_care_management_params)
        format.html do
          redirect_to redirect_path(controller_name, @care_management),
                      notice: 'care_management was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @care_management }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @care_management.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /care_managements/1 or /care_managements/1.json
  def destroy
    @care_management.destroy

    respond_to do |format|
      format.html { redirect_to care_managements_url, notice: 'care_management was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_care_management
    @care_management = CareManagement.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def care_management_params
    params.require(:care_management).permit(
      :section, :name, :care_management_type, :care_management_category, :status,
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
      new_care_management_action_steps: %i[
        id step_number name interaction artifact_type artifact_text
        artifact_url artifact_video _destroy
      ]
    )
  end

  def set_header
    @header = 'Care Management'
  end

  def set_members_hash
    if params[:link_to_id].present?
      @members_hash = {
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
      }
    elsif action_name == 'edit' && @care_management.member_selections.last.criteria_type == 'Pre selected'
      member_selection = @care_management.member_selections.last
      @members_hash = {
        link_to_id: member_selection.link_to_id,
        link_to_type: member_selection.link_to_type,
        milestone_id: member_selection.milestone_id,
        status: member_selection.status
      }
    end
  end  
end
