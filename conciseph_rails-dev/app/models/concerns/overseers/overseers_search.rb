# frozen_string_literal: true

module Overseers
  module OverseersSearch
    extend ActiveSupport::Concern

    class_methods do
      def overseers_search(params)
        table_name = to_s.underscore
        query = 'status IN (:status)'
        search_obj = { status: [1, 2] }
        query += " AND #{table_name}_category = :category" if params[:category].present?
        search_obj[:category] = send("#{table_name}_categories")[params[:category]]

        page = params[:page].to_i.nonzero? || 1
        page_size = params[:page_size].to_i.nonzero? || 10

        where(query, search_obj).page(page).per_page(page_size).order('created_at DESC')
      end
    end
  end
end
