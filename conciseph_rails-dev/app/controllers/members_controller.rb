# frozen_string_literal: true

class MembersController < ApplicationController
  layout 'admin'

  def index
    @total_members = Member.count
    @total_users = if current_user.refer.present?
      User.where('is_admin = ? and super_admin = ? and otp_verified= ? and referred_by = ?', false, false,
                              true, current_user.refer.code).count
      else
        0
      end

    # for now i have commented that
    # @total_members = @total_members + @total_users

    @members = Member.search(params).order(created_at: :desc)
    @members_import = MembersImport.new

    respond_to do |format|
      format.html do
        @members = @members.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @members = @members.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @members
      end
    end
  end
end
