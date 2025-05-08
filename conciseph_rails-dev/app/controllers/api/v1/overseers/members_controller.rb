# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class MembersController < Api::V1::Overseers::ApiController
        def index
          @members = Member.all.page(params[:page].present? ? params[:page] : 1).per_page(params[:page_size].to_i.nonzero? || 10).order(created_at: :desc)
        end
      end
    end
  end
end
