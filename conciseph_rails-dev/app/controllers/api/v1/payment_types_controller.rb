# frozen_string_literal: true

module Api
  module V1
    class PaymentTypesController < ApiController
      def index
        @payment_types = PaymentType.all
      end
    end
  end
end
