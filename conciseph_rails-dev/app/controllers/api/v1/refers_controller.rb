# frozen_string_literal: true

module Api
  module V1
    class RefersController < ApiController
      def index
        @refers = Refers.all
      end
    end
  end
end
