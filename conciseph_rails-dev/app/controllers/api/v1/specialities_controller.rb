# frozen_string_literal: true

module Api
  module V1
    class SpecialitiesController < ApiController
      def index
        @specialities = Speciality.all
      end
    end
  end
end
