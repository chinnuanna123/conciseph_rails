# frozen_string_literal: true

class Milestone < ApplicationRecord
  belongs_to :milestonable, polymorphic: true
  has_many :action_steps, dependent: :destroy
  has_many :user_action_milestones
  accepts_nested_attributes_for :action_steps, allow_destroy: true
end
