# frozen_string_literal: true

class FeedbacksController < ApplicationController
  layout 'admin'
  def index
    @feedbacks = Feedback.search(params, current_user.refer.code)
    respond_to do |format|
      format.html do
        @feedbacks = @feedbacks.paginate(page: params[:page], per_page: 10)
      end
      format.js do
        @feedbacks = @feedbacks.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        render json: @feedbacks
      end
    end
  end
end
