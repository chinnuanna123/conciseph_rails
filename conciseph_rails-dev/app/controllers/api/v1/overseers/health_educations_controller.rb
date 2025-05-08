# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class HealthEducationsController < Api::V1::Overseers::ApiController
        def index
          @health_educations = HealthEducation.overseers_search(params)
        end
      end
    end
  end
end
