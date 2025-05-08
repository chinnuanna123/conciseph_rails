# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class MemberCompliancesController < Api::V1::Overseers::ApiController
        def index
          @users = User.where("updated_at >= CURRENT_DATE - INTERVAL '90 days'").where.not(medication_adhere_status: 'Not Started').page(params[:page].to_i.nonzero? || 1).per_page(params[:page_size].to_i.nonzero? || 10).order(created_at: :desc)
        end
      end
    end
  end
end
