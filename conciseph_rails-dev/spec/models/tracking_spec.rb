# frozen_string_literal: true

# spec/models/tracking_spec.rb

require 'rails_helper'

RSpec.describe Tracking, type: :model do
  let(:user) { create(:user) }
  subject { create(:tracking, user: user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:tracking_for) }

    it 'validates exclusion of tracking_for' do
      invalid_tracking = build(:tracking, tracking_for: nil)
      expect(invalid_tracking).not_to be_valid
      expect(invalid_tracking.errors[:tracking_for]).to include("can't be blank")

      expect { subject.update!(tracking_for: 999) }.to raise_error(ArgumentError)
    end
  end

  describe '.search' do
    let!(:referrer) { create(:user, referred_by: 'REF123') }
    let!(:tracked_user) { create(:user, referred_by: 'REF123') }
    let!(:tracking_record) { create(:tracking, user: tracked_user, tracking_for: Tracking.tracking_fors[:USERS]) }

    it 'returns trackings for users referred by a specific code' do
      result = Tracking.search({ search: '' }, 'REF123')
      expect(result).to include(tracking_record)
    end

    it 'filters by user email and name when search term is present' do
      result = Tracking.search({ search: tracked_user.email }, 'REF123')
      expect(result).to include(tracking_record)

      result = Tracking.search({ search: tracked_user.name }, 'REF123')
      expect(result).to include(tracking_record)
    end

    # it 'filters by tracking_for code when search term matches' do
    #   params = { search: 'users' }
    #   result = Tracking.search(params, 'REF123')

    #   # Debugging line to check the result
    #   puts "Search Result: #{result.inspect}"

    #   expect(result).to include(tracking_record)
    # end

    it 'matches tracking_for when valid tracking code is provided' do
      result = Tracking.search({ search: 'USERS' }, 'REF123')
      expect(result).to include(tracking_record)

      # Ensure it returns no results when searching for an invalid tracking_for
      invalid_result = Tracking.search({ search: 'INVALID_CODE' }, 'REF123')
      expect(invalid_result).not_to include(tracking_record)
    end

    it 'handles searches that include both user attributes and tracking_for' do
      result = Tracking.search({ search: 'USERS' }, 'REF123')
      expect(result).to include(tracking_record)

      result_with_email = Tracking.search({ search: tracked_user.email }, 'REF123')
      expect(result_with_email).to include(tracking_record)

      result_with_name = Tracking.search({ search: tracked_user.name }, 'REF123')
      expect(result_with_name).to include(tracking_record)
    end
  end
end
