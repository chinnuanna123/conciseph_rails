# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class AnnouncementsController < Api::V1::Overseers::ApiController
        def index
          @announcements = Announcement.overseers_search(params)
        end
      end
    end
  end
end
