# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < ApiController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      def create
        # binding.pry

        @payment = Payment.new(payment_params)
        # @payment.user_id = current_user.id
        # current_user.payments.update_all(active: false) if @payment.valid?
        Payment.where(email: @payment.email).update_all(active: false) if @payment.valid?
        if payment_params[:expiry_date].present?
          @payment.expiry_date = Time.at(0, payment_params[:expiry_date],
                                         :millisecond).to_datetime
        end

        @payment.active = true
        unless @payment.save
          render status: 500, json: { status: 'error', errors: @payment.errors.full_messages }
          return true
        end

        @payment.user.generate_otp if @payment.user.present?

        render status: 200,
               json: { status: 'success',
                       data: true }
      end

      private

      def payment_params
        params.permit(:amount, :currency, :expiry_date, :purchase_id, :order_id, :sku_code,
                      :purchase_type, :email)
      end
    end
  end
end
