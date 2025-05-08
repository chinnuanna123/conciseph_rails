# frozen_string_literal: true

module Api
  module V1
    class InsuranceTypesController < ApiController
      def index
        @insurance_types = InsuranceType.all
      end
    end
  end
end
