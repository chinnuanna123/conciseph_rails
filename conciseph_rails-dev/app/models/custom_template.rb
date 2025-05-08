# frozen_string_literal: true

class CustomTemplate < ApplicationRecord
  has_many :milestones, as: :milestonable, dependent: :destroy
  has_many :action_steps, through: :milestones
  accepts_nested_attributes_for :milestones, allow_destroy: true
  include Duplicatable
  # accepts_nested_attributes_for :action_steps, allow_destroy: true
  has_one_attached :icon
  attr_accessor :custom_template_id

  before_save :set_default_attachment_if_not_present, if: -> { custom_template_id.present? }
  enum campaign_name: {
    'Quality Improvement Goal': 0,
    'Announcements': 1,
    'Health Events': 2,
    'Health Education': 3,
    'Feedback / Survey': 4,
    'Complaince': 5,
    'Care Management': 6,
    'Chronic Condition Management Goal': 7
  }
  enum functional_area: {
    population_health_management: 0,
    complex_care_management: 1,
    case_management: 2,
    chronic_disease_management: 3,
    transitional_care_management: 4,
    patient_safety: 5,
    member_services: 6,
    health_education: 7,
    health_equity: 8
  }

  def get_category
    model_name = CUSTOM_TEMPLATE__HASH.key(campaign_name_before_type_cast).to_s
    return unless model_name.present?

    model_name.constantize.send("#{model_name.underscore}_categories").key(category)
  end

  def get_model
    name = CUSTOM_TEMPLATE__HASH.key(campaign_name_before_type_cast).to_s
    model = name.constantize
  end

  def get_section
    get_model.sections.key(section).to_s
  end

  def self.search(params)
    functional_area = params[:functional_area]
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    custom_templates = if functional_area.present?
                         where(functional_area: functional_area)
                       else
                         all
                       end
    custom_templates.page(page).per(per_page).order('created_at DESC')
  end

  def icon_url
    icon.attached? ?  Rails.application.routes.url_helpers.rails_blob_url(icon,
      only_path: true) : ''
  end
end
