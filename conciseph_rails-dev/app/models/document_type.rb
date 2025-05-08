# frozen_string_literal: true

class DocumentType < ApplicationRecord
  validates :code, uniqueness: { scope: :kind }

  enum kind: {
    PERSON: 0,
    PET: 1
  }
end
