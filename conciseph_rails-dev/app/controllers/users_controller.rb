# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'admin'
  def index
    # (family head activity last 30 days) / Users Enrolled (family head)
    # preferred_language category specifix
    # ethinicity category specifix
    # age group
    @data = Chart::UserChartData.new(current_user).call

    @users = User.search(params, current_user.refer.code).order(created_at: :desc)
    respond_to do |format|
      format.html do
        @users = @users.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @users = @users.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @users
      end
    end
  end
end
