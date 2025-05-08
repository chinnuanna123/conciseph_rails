# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class MedicationsController < Api::V1::Overseers::ApiController
        def index
          @medications = Medication.all.page(params[:page].to_i.nonzero? || 1).per_page(params[:page_size].to_i.nonzero? || 10).order(created_at: :desc)
        end
      end
    end
  end
end
