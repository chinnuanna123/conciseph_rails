# frozen_string_literal: true

module Api
  module V1
    class TrackingsController < ApiController
      # skip_before_action :authenticate_user!

      def create
        unless current_user.present? && params[:data].present?
          render status: 500, json: { status: 'error', errors: ['invalid params'] }
          return true
        end

        ActiveRecord::Base.transaction do
          params[:data].each do |record|
            tracking = Tracking.where(user_id: current_user.id, tracking_for: record[:tracking_for]).first_or_initialize
            tracking.counter = tracking.counter + begin
              record[:counter].to_i
            rescue StandardError
              0
            end
            tracking.save
          end
          render status: 200, json: { status: 'success', message: 'success' }
        end
      rescue StandardError => e
        render status: 500, json: { status: 'error', errors: [e] }
      end
    end
  end
end
