# frozen_string_literal: true

class CustomTemplatesController < ApplicationController
  before_action :check_super_admin
  layout 'admin'
  load_and_authorize_resource
  before_action :set_custom_template, only: %i[show edit update destroy]

  # GET /custom_templates or /custom_templates.json
  def index
    @custom_templates = CustomTemplate.search(params)
    @records_with_categories = CustomTemplate.select(:functional_area).group(:functional_area).count
    # render layout: 'admin'
  end

  # GET /custom_templates/1 or /custom_templates/1.json
  def show
    @custom_template = CustomTemplate.eager_load(action_steps: %i[artifact_document_attachment
                                                                  artifact_video_attachment]).find(params[:id])
  end

  # GET /custom_templates/new
  def new
    if params[:custom_template_id].present?
      custom_template = CustomTemplate.find(params[:custom_template_id])
      @custom_template = custom_template.duplicate_with_assn(params)
      name = CUSTOM_TEMPLATE__HASH.key(custom_template.campaign_name_before_type_cast).to_s
      categories = "#{name.underscore}_categories"
      model = name.constantize

      @section_options = model.sections.to_a
      @category_options = model.send(categories).to_a
    else
      @custom_template = CustomTemplate.new
      @custom_template.milestones.build.action_steps.build
    end
  end

  # GET /custom_templates/1/edit
  def edit
    model = @custom_template.get_model
    categories = "#{model.to_s.underscore}_categories"
    @section_options = model.sections.to_a
    @category_options = model.send(categories).to_a
  end

  # POST /custom_templates or /custom_templates.json
  def create
    @custom_template = CustomTemplate.new(custom_template_params)
    respond_to do |format|
      if @custom_template.save
        format.html { redirect_to custom_templates_url, notice: 'Custom template was successfully created.' }
        format.json { render :show, status: :created, location: @custom_template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @custom_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_templates/1 or /custom_templates/1.json
  def update
    respond_to do |format|
      if @custom_template.update(custom_template_params)
        format.html { redirect_to custom_templates_url, notice: 'Custom template was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @custom_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_templates/1 or /custom_templates/1.json
  def destroy
    @custom_template.destroy

    respond_to do |format|
      format.html { redirect_to custom_templates_url, notice: 'Custom template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_category
    # binding.pry
    campaign_code = CustomTemplate.campaign_names[params[:campaign_name]] if params[:campaign_name].present?
    name = CUSTOM_TEMPLATE__HASH.key(campaign_code)
    categories = "#{name.to_s.underscore}_categories"
    model = name.to_s.constantize
    result_hash = {}
    result_hash['category'] = model.send(categories).to_a
    result_hash['section'] = model.sections.to_a
    render json: result_hash
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_custom_template
    @custom_template = CustomTemplate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def custom_template_params
    params.require(:custom_template).permit(:name, :category, :section, :description, :icon, :campaign_name, :save_to_draft, :functional_area, :custom_template_id, :is_active,
                                            milestones_attributes: [
                                              :id, :_destroy, action_steps_attributes: %i[
                                                id step_number name interaction message action artifact_type
                                                artifact_text artifact_url artifact_video artifact_document _destroy
                                              ]
                                            ],
                                            action_steps_attributes: %i[
                                              id step_number name interaction message action artifact_type
                                              artifact_text artifact_url artifact_video artifact_document _destroy
                                            ])
  end
end
