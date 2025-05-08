# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SupportNeed, type: :model do
  let(:user) { create(:user) } # Assuming you have a User factory

  describe 'validations' do
    it 'is valid with valid attributes' do
      support_need = build(:support_need, user: user, code: 'No need for support services')
      expect(support_need).to be_valid
    end

    it 'is invalid without prefered_days when code is "Prefer Day"' do
      support_need = build(:support_need, user: user, code: 'Prefer Day', prefered_days: nil)
      expect(support_need).not_to be_valid
      expect(support_need.errors[:prefered_days]).to include("can't be blank")
    end

    it 'is invalid without prefered_times when code is "Prefer Time"' do
      support_need = build(:support_need, user: user, code: 'Prefer Time', prefered_times: nil)
      expect(support_need).not_to be_valid
      expect(support_need.errors[:prefered_times]).to include("can't be blank")
    end
  end

  describe 'enum' do
    it 'has the correct codes' do
      expect(SupportNeed.codes.keys).to include(
        'No need for support services',
        'Transportation',
        'Food',
        'Prefer Day',
        'Prefer Time',
        'Childcare',
        'Language Translator'
      )
    end
  end

  describe '#prefered_days_names' do
    it 'returns the names of preferred days' do
      support_need = create(:support_need, user: user, code: 'Prefer Day', prefered_days: [0, 1]) # Monday and Tuesday
      expect(support_need.prefered_days_names).to match_array(%i[Monday Tuesday])
    end
  end

  describe '#prefered_times_names' do
    it 'returns the names of preferred times' do
      support_need = create(:support_need, user: user, code: 'Prefer Time', prefered_times: [0, 2]) # 7am - 9am and 5pm - 8pm
      expect(support_need.prefered_times_names).to match_array([:'7am - 9am', :'5pm - 8pm'])
    end
  end
end
