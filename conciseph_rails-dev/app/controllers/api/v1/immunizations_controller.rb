# frozen_string_literal: true

module Api
  module V1
    class ImmunizationsController < ApiController
      def index
        @immunizations = Immunization.all
      end
    end
  end
end
