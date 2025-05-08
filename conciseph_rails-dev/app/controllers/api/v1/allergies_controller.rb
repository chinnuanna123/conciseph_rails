# frozen_string_literal: true

module Api
  module V1
    class AllergiesController < ApiController
      def index
        @allergies = Allergy.all
      end
    end
  end
end
