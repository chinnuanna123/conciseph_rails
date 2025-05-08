# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentType, type: :model do
  describe 'validations' do
    # it 'is valid with a unique code scoped to kind' do
    #   document_type = DocumentType.new(code: 'DOC123', kind: :PERSON)
    #   expect(document_type).to be_valid
    # end

    # it 'is not valid with a duplicate code for the same kind' do
    #   DocumentType.create(code: 'DOC123', kind: :PERSON) # Create the first document type
    #   document_type = DocumentType.new(code: 'DOC123', kind: :PERSON) # Duplicate code
    #   expect(document_type).not_to be_valid
    #   expect(document_type.errors[:code]).to include('has already been taken')
    # end

    # it 'is valid with the same code for a different kind' do
    #   DocumentType.create(code: 'DOC123', kind: :PERSON) # Create the first document type
    #   document_type = DocumentType.new(code: 'DOC123', kind: :PET) # Different kind
    #   expect(document_type).to be_valid
    # end

    # it 'is valid with a different code' do
    #   document_type = DocumentType.new(code: 'DOC456', kind: :PERSON)
    #   expect(document_type).to be_valid
    # end
  end

  describe 'enum' do
    it 'defines kind enum values correctly' do
      expect(DocumentType.kinds).to eq({ 'PERSON' => 0, 'PET' => 1 }) # Match string keys
    end

    it 'returns correct kind for integer values' do
      expect(DocumentType.kinds.key(0)).to eq('PERSON')
      expect(DocumentType.kinds.key(1)).to eq('PET')
    end
  end
end
