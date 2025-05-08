# frozen_string_literal: true

module Api
  module V1
    class PetServiceProvidersController < ApiController
      def index
        @pet_sevice_providers = ::PetServiceProvider.all
      end
    end
  end
end
