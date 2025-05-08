# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class TimelyRecoveryGoalsController < Api::V1::Overseers::ApiController
        def index
          @timely_recovery_goals = TimelyRecoveryGoal.overseers_search(params)
        end
      end
    end
  end
end
