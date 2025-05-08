# frozen_string_literal: true

module Api
  module V1
    class DocumentTypesController < ApiController
      def index
        @document_types = DocumentType.all
      end
    end
  end
end
