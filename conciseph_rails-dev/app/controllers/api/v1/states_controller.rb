# frozen_string_literal: true

module Api
  module V1
    class StatesController < ApiController
      def index
        @states = State.all
      end
    end
  end
end
