# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class HealthEventsController < Api::V1::Overseers::ApiController
        def index
          @health_events = HealthEvent.overseers_search(params)
        end
      end
    end
  end
end
