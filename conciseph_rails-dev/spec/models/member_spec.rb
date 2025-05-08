# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member, type: :model do
  subject { create(:member) }

  describe 'validations' do
    it { should validate_presence_of(:member_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }

    it { should validate_uniqueness_of(:member_id).case_insensitive }
    it { should validate_uniqueness_of(:email) }

    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe '#date_format_checker' do
    context 'when birth_date is valid' do
      it 'formats the birth_date correctly' do
        member = build(:member, birth_date: '1990-05-10')
        member.valid?
        expect(member.birth_date).to eq('1990-05-10')
      end
    end

    context 'when birth_date is out of valid range' do
      it 'adds an error if the year is too old or in the future' do
        member = build(:member, birth_date: '1890-01-01')
        member.valid?
        expect(member.errors[:birth_date]).to include('is not in a valid range')

        member.birth_date = '2100-01-01'
        member.valid?
        expect(member.errors[:birth_date]).to include('is not in a valid range')
      end
    end

    context 'when birth_date is invalid' do
      it 'adds an error for invalid date' do
        member = build(:member, birth_date: 'invalid-date')
        member.valid?
        expect(member.errors[:base]).to include('invalid Date')
      end
    end
  end

  describe '.search' do
    let!(:member1) { create(:member, name: 'John Doe', email: 'john.doe@example.com', zip_code: '12345') }
    let!(:member2) { create(:member, name: 'Jane Smith', email: 'jane.smith@example.com', zip_code: '67890') }

    context 'when search params are present' do
      it 'returns members matching the name' do
        result = Member.search(search: 'John')
        expect(result).to include(member1)
        expect(result).not_to include(member2)
      end

      it 'returns members matching the email' do
        result = Member.search(search: 'jane.smith@example.com')
        expect(result).to include(member2)
        expect(result).not_to include(member1)
      end

      it 'returns members matching the zip code' do
        result = Member.search(search: '12345')
        expect(result).to include(member1)
        expect(result).not_to include(member2)
      end
    end

    context 'when search params are not present' do
      it 'returns all members' do
        result = Member.search({})
        expect(result).to include(member1, member2)
      end
    end
  end
end
