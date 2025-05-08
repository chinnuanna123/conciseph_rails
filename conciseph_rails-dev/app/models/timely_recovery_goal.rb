# frozen_string_literal: true

class TimelyRecoveryGoal < ApplicationRecord
  has_many :user_actions, as: :actionable, dependent: :destroy
  has_many :milestones, as: :milestonable, dependent: :destroy
  has_many :action_steps, through: :milestones
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  include Launchable
  include Overseers::OverseersSearch
  include Duplicatable
  attr_accessor :goal_id, :template_id

  before_save :set_default_attachment_if_not_present, if: -> { goal_id.present? || template_id.present? }
  validates :name, :timely_recovery_goal_type, :timely_recovery_goal_category, :status, :section, presence: true

  accepts_nested_attributes_for :milestones, allow_destroy: true

  has_one_attached :icon

  enum section: {
    'Timely Recovery': 0
  }

  enum timely_recovery_goal_category: {
    'Follow Up Care': 111,
    'Medication Refill': 112,
    'Program Enrollment': 113,
    'Referral Completion': 114
  }, _prefix: true

  enum status: {
    'Draft': 0,
    'Active': 1,
    'Completed': 2
  }

  enum timely_recovery_goal_type: {
    'Quality Measures': 0
  }

  def icon_url
    icon.attached? ? Rails.application.routes.url_helpers.rails_blob_url(icon,only_path: true) : ''
  end

  def self.search(params)
    category = params[:category]
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    query = eager_load(:user_actions, :owner).all
    query = query.where(timely_recovery_goal_category: category) if category.present?

    query.page(page).per(per_page)
  end
end
