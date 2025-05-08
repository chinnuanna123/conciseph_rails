# frozen_string_literal: true

# spec/models/visit_type_spec.rb

require 'rails_helper'

RSpec.describe VisitType, type: :model do
  subject { create(:visit_type) }

  describe 'validations' do
    it 'validates uniqueness of code' do
      visit_type_duplicate = build(:visit_type, code: subject.code)

      expect(visit_type_duplicate).not_to be_valid
      expect(visit_type_duplicate.errors[:code]).to include('has already been taken')
    end

    it 'is valid with unique code' do
      visit_type = build(:visit_type, code: 'NEW_CODE')

      expect(visit_type).to be_valid
    end
  end
end
