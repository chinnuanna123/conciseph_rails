# frozen_string_literal: true

class MemberFeedback < ApplicationRecord
  after_save :create_user_actions
  include Launchable
  include Overseers::OverseersSearch
  include Duplicatable
  attr_accessor :goal_id, :template_id

  before_save :set_default_attachment_if_not_present, if: -> { goal_id.present? || template_id.present? }
  has_many :milestones, as: :milestonable, dependent: :destroy
  has_many :action_steps, through: :milestones
  has_many :member_selections, as: :selectable, dependent: :destroy
  has_many :user_actions, as: :actionable, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :name, :member_feedback_type, :member_feedback_category, :status, :start_date, :end_date, :section,
            presence: true
  validate :date_checker

  accepts_nested_attributes_for :milestones, allow_destroy: true
  accepts_nested_attributes_for :member_selections, allow_destroy: true

  has_one_attached :icon

  enum section: {
    'Member Experience': 0,
    'Member Opinion': 1
  }

  enum member_feedback_category: {
    'Care': 0,
    'Service': 1,
    'Member Forms': 2,
    'CAPHS': 3,
    'Health Plan': 4,
    'Care Barriers': 5,
    'Condition Management': 6
  }, _prefix: true

  enum status: {
    'Draft': 0,
    'Active': 1,
    'Completed': 2
  }

  enum member_feedback_type: {
    'Survey / Feedback': 0
  }

  def icon_url
    icon.attached? ? Rails.application.routes.url_helpers.rails_blob_url(icon,only_path: true) : ''
  end

  private

  def date_checker
    errors.add(:base, 'Start date should be before the end date') if start_date && end_date && start_date > end_date
  end

  def create_user_actions
    return unless status == 'Active'

    CreateUserActionsJob.perform_later(self)
  end

  def self.search(params)
    category = params[:category]
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    query = eager_load(:user_actions, :owner).all
    query = query.where(member_feedback_category: category) if category.present?

    query.page(page).per(per_page)
  end
end
