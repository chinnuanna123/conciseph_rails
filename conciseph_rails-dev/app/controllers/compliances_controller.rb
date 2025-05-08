# frozen_string_literal: true

class CompliancesController < ApplicationController
  
  layout 'campaign'
  before_action :set_header
  before_action :set_compliance, only: %i[show edit update destroy launch review]
  before_action -> { set_members_hash(@compliance) }, only:  %i[new edit]

  def index
    @records_with_categories = Compliance.select(:compliance_category).group(:compliance_category).count
    @compliances = Compliance.search(params).order(created_at: :desc)
    @user_actions_count = Compliance.joins(:user_actions).order(created_at: :desc).group(:id).count
    respond_to do |format|
      format.html do
        @compliances =  @compliances.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @compliances =  @compliances.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json:  @compliances
      end
    end
    render layout: 'admin'
  end

  def show
    @user_actions = UserAction.search(params)
     set_charts_data(@compliance)
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
      compliance = Compliance.find(params[:goal_id])
      @compliance = compliance.duplicate_with_assn(params)
    elsif params[:template_id]
      custom_template = CustomTemplate.find(params[:template_id])
      @compliance = custom_template.duplicate_with_assn(params)
      @compliance.member_selections.build
    elsif params[:by_goal].present?
      @compliance = Compliance.new
      @compliance.milestones.build.action_steps.build
      @compliance.member_selections.where(
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
      ).build
    else
      @compliance = Compliance.new
      # @compliance.member_selections.build
      @compliance.member_selections.build
      @compliance.milestones.build.action_steps.build
    end
  end

  def create
    @compliance = Compliance.new(compliance_params)
    @compliance.status = 'Draft'
    @compliance.owner_id = current_user.id

    respond_to do |format|
      if @compliance.save
        format.html do
          redirect_to redirect_path(controller_name, @compliance), notice: 'compliance was successfully created.'
        end
        format.js
        format.json { render :edit, status: :created, location: @compliance }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @compliance.errors, status: :unprocessable_entity }
        format.js { render 'error' }
      end
    end
  end

  def launch
    @user_actions_count = @compliance.user_actions_count
    respond_to do |format|
      if @compliance.can_launch? && @compliance.update(status: 'Active')
        format.html
        format.js
      else
        format.html { redirect_to review_compliance_path(@compliance), status: :unprocessable_entity }
      end
    end
  end

  def review
    respond_to(&:html)
  end

  # PATCH/PUT /compliances/1 or /compliances/1.json
  def update
    update_compliance_params = compliance_params.merge(status: 'Draft')
    respond_to do |format|
      if @compliance.update(update_compliance_params)
        format.html do
          redirect_to redirect_path(controller_name, @compliance), notice: 'compliance was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @compliance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @compliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compliances/1 or /compliances/1.json
  def destroy
    @compliance.destroy

    respond_to do |format|
      format.html { redirect_to compliances_url, notice: 'compliance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_compliance
    @compliance = Compliance.find(params[:id])
  end

  def compliance_params
    params.require(:compliance).permit(
      :section, :name, :compliance_type, :compliance_category, :status,
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
    @header = 'New Feedback / Survey'
  end

end
