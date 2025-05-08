# frozen_string_literal: true

# spec/models/member_selection_spec.rb

require 'rails_helper'

RSpec.describe MemberSelection, type: :model do
  subject { build(:member_selection) } # Create a subject for tests

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    # it 'is not valid without a selectable type' do
    #   subject.selectable_type = nil
    #   expect(subject).not_to be_valid
    #   expect(subject.errors[:selectable_type]).to include("can't be blank")
    # end
  end

  describe '#criteria_description' do
    context 'when criteria_type is Age' do
      it 'returns the correct description for "Is equal to"' do
        subject.criteria_type = 'Age'
        subject.criteria_sub_type = 'Is equal to'
        subject.criterial_value = '30'
        subject.unit = 'years'
        expect(subject.criteria_description).to eq('30 years')
      end

      it 'returns the correct description for "Greater Than"' do
        subject.criteria_type = 'Age'
        subject.criteria_sub_type = 'Greater Than'
        subject.criterial_value = '30'
        subject.unit = 'years'
        expect(subject.criteria_description).to eq('Greather than 30 years')
      end

      it 'returns the correct description for "Less Than"' do
        subject.criteria_type = 'Age'
        subject.criteria_sub_type = 'Less Than'
        subject.criterial_value = '30'
        subject.unit = 'years'
        expect(subject.criteria_description).to eq('Less than 30 years')
      end

      it 'returns the correct description for "Range"' do
        subject.criteria_type = 'Age'
        subject.criteria_sub_type = 'Range'
        subject.criterial_start_range = 25
        subject.criterial_end_range = 35
        subject.unit = 'years'
        expect(subject.criteria_description).to eq('Between (25 - 35) years')
      end

      it 'returns the correct description for not "Range"' do
        subject.criteria_type = 'Age'
        subject.criteria_sub_type = ''
        subject.unit = 'years'
        subject.criterial_value = '25'
        expect(subject.criteria_description).to eq('25')
      end
    end

    context 'when criteria_type is All Members' do
      it 'returns "All Members"' do
        subject.criteria_type = 'All Members'
        expect(subject.criteria_description).to eq('All Members')
      end
    end

    context 'when criteria_type is not Age or All Members' do
      it 'returns the criterial_value' do
        subject.criteria_type = 'Gender'
        subject.criterial_value = 'male'
        expect(subject.criteria_description).to eq(subject.criterial_value)
      end
    end
  end
end
