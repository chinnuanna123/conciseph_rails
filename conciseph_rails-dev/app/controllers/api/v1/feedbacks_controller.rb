# frozen_string_literal: true

module Api
  module V1
    class FeedbacksController < ApiController
      # before_action :set_feedback, only: %i[ show edit update destroy ]
      # skip_before_action :authenticate_user!
      # # GET /feedbacks or /feedbacks.json
      # def index
      #   @feedbacks = Feedback.all
      # end

      # # GET /feedbacks/1 or /feedbacks/1.json
      # def show
      # end

      # # GET /feedbacks/new
      # def new
      #   @feedback = Feedback.new
      # end

      # # GET /feedbacks/1/edit
      # def edit
      # end

      # POST /feedbacks or /feedbacks.json
      def create
        @feedback = Feedback.new(feedback_params)
        @feedback.user_id = current_user.id
        unless @feedback.save
          render status: 500, json: { status: 'error', errors: @feedback.errors.full_messages }
          return true
        end

        render status: 200, json: { status: 'success', data: @feedback.as_json.slice('id', 'ratings', 'message') }
      end

      # # PATCH/PUT /feedbacks/1 or /feedbacks/1.json
      # def update
      #   respond_to do |format|
      #     if @feedback.update(feedback_params)
      #       format.html { redirect_to @feedback, notice: "Feedback was successfully updated." }
      #       format.json { render :show, status: :ok, location: @feedback }
      #     else
      #       format.html { render :edit, status: :unprocessable_entity }
      #       format.json { render json: @feedback.errors, status: :unprocessable_entity }
      #     end
      #   end
      # end

      # # DELETE /feedbacks/1 or /feedbacks/1.json
      # def destroy
      #   @feedback.destroy
      #   respond_to do |format|
      #     format.html { redirect_to feedbacks_url, notice: "Feedback was successfully destroyed." }
      #     format.json { head :no_content }
      #   end
      # end

      private

      # Only allow a list of trusted parameters through.
      def feedback_params
        params.require(:feedback).permit(:ratings, :message)
      end
    end
  end
end
