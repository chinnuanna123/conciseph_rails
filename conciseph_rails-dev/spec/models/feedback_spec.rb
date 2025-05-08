# frozen_string_literal: true

# spec/models/feedback_spec.rb
require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user) # Create a user using the user factory
      feedback = build(:feedback, user: user)
      expect(feedback).to be_valid
    end

    it 'is not valid without a user' do
      feedback = build(:feedback, user: nil)
      expect(feedback).to_not be_valid
    end

    # it 'is not valid without a message' do
    #   user = create(:user)
    #   feedback = build(:feedback, user: user, message: nil)
    #   expect(feedback).to_not be_valid
    # end

    # it 'is not valid without a ratings' do
    #   user = create(:user)
    #   feedback = build(:feedback, user: user, ratings: nil)
    #   expect(feedback).to_not be_valid
    # end
  end

  describe '.search' do
    let!(:user) { create(:user, referred_by: 'REF123') }
    let!(:feedback1) { create(:feedback, user: user, message: 'Great service!') }
    let!(:feedback2) { create(:feedback, user: user, message: 'Not satisfied') }
    let!(:feedback3) { create(:feedback, user: user, message: 'Excellent!') }

    context 'when searching by message' do
      it 'returns feedback containing the search term' do
        result = Feedback.search({ search: 'great' }, 'REF123')
        expect(result).to include(feedback1)
        expect(result).not_to include(feedback2)
      end

      it 'returns no feedback if there are no matches' do
        result = Feedback.search({ search: 'unknown' }, 'REF123')
        expect(result).to be_empty
      end
    end

    context 'when there are no user matches' do
      it 'returns no feedback' do
        result = Feedback.search({ search: 'service' }, 'UNKNOWN_CODE')
        expect(result).to be_empty
      end
    end
  end
end
