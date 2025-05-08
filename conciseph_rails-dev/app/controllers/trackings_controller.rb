# frozen_string_literal: true

class TrackingsController < ApplicationController
  layout 'admin'
  def index
    @trackings = Tracking.search(params, current_user.refer.code)
    respond_to do |format|
      format.html do
        @trackings = @trackings.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @trackings = @trackings.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @trackings
      end
    end
  end
end
