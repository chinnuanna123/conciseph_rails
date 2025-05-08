# frozen_string_literal: true

class DashboardNewController < ApplicationController
  layout 'admin'

  def index
    authorize! :admin_dashboard, current_user
    @data = Dashboard::CountersService.new.call
  end

  def get_members
    if params['data']['link_to_id'].present?
      new_params = JSON.parse(params['data']).transform_keys(&:to_sym)
      @members = UserActions::CreateService.new(Goal.first, params: new_params, current_user: current_user).members
    else
      @members = UserActions::CreateService.new(Goal.first, params: params, current_user: current_user).members #dummy actionable
    end
    @members_count = @members.count
    respond_to do |format|
      format.js
    end
  end
end
