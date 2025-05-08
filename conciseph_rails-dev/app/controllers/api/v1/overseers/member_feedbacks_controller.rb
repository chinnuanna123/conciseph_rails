# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class MemberFeedbacksController < Api::V1::Overseers::ApiController
        def index
          @member_feedbacks = MemberFeedback.overseers_search(params)
        end
      end
    end
  end
end
