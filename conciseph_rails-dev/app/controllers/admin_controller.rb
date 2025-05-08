# frozen_string_literal: true

class AdminController < ApplicationController
  # skip_before_action :authenticate_user!
  before_action :check_super_admin
  def index
    @refer = Refer.find_by(owner_id: current_user.id)
    @users = User.where('referred_by = ?', @refer.code)
    @total_users = @users.count
    @referral_limit = @refer.no_of_users
    @used_referrals = @total_users
    @total_feedbacks = Feedback.where(user_id: @users.pluck(:id)).count
    @trackings = Tracking.where(user_id: @users.pluck(:id)).order(created_at: :desc).limit(10)
  end

  def quality_improvements; end

  def announcements; end

  def health; end

  def health_details; end

  def demo_health; end

  def total_referrals; end

  def referrals_used; end

  def review_support; end

  def approved_support; end

  def member_support; end

  def support_service; end

  def announcement_details; end

  def demo_announcement; end

  def referral_providers; end

  def check_super_admin
    redirect_to rails_admin_path if current_user.super_admin
  end

  def demo_workflow; end

  def demo_workflow_listing; end

  def quality_improvement_details; end
end
