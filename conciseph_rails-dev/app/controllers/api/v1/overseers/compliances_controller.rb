# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class CompliancesController < Api::V1::Overseers::ApiController
        def index
          @compliances = Compliance.overseers_search(params)
        end
      end
    end
  end
end
