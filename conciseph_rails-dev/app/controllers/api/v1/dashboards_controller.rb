# frozen_string_literal: true

module Api
  module V1
    class DashboardsController < ApiController
      before_action :set_user_or_family_member, only: [:counters_summary]

      def counters_summary
        @counters_hash = UserActions::FetchCountersSummary.new(@user).call
      end

      private

      def set_user_or_family_member
        @user = User.find_by(id: params[:family_member_id]) || current_user
      end
    end
  end
end
