# frozen_string_literal: true

module Api
  module V1
    class SymptomsController < ApiController
      skip_before_action :authenticate_user!
      def index
        @symptoms = Symptom.all
      end
    end
  end
end
