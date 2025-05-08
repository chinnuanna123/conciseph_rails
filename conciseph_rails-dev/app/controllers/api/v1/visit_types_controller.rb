# frozen_string_literal: true

module Api
  module V1
    class VisitTypesController < ApiController
      def index
        @visit_types = VisitType.all
      end
    end
  end
end
