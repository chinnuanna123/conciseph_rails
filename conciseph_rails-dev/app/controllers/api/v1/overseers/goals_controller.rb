# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class GoalsController < Api::V1::Overseers::ApiController
        def index
          @goals = Goal.overseers_search(params)
        end
      end
    end
  end
end
