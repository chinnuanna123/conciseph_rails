# frozen_string_literal: true

# spec/models/custom_template_spec.rb
require 'rails_helper'

RSpec.describe CustomTemplate, type: :model do
  let(:custom_template) { build(:custom_template) }

  describe 'associations' do
    it { should have_many(:action_steps).dependent(:destroy) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(custom_template).to be_valid
    end
  end

  describe 'icon attachment' do
    let!(:custom_template_with_icon) { create(:custom_template, :with_icon) }
    it 'attaches an icon' do
      expect(custom_template_with_icon.icon).to be_attached
    end
  end

  describe '#get_category' do
    it 'retrieves the correct category' do
      # binding.pry
      expect(custom_template.get_category).to eq(MemberFeedback.member_feedback_categories.key(1)) # Replace with the actual value
    end
  end

  describe '#get_model' do
    it 'get_model' do
      expect(custom_template.get_model).to eql(MemberFeedback)
    end
  end

  describe '#get_section' do
    it 'get_section' do
      expect(custom_template.get_section).to eql(MemberFeedback.sections.key(1))
    end
  end

  describe '#search' do
    let!(:template1) { create(:custom_template, functional_area: :population_health_management) }
    let!(:template2) { create(:custom_template, functional_area: :case_management) }

    it 'returns templates based on functional_area' do
      results = CustomTemplate.search(functional_area: 'population_health_management')
      expect(results).to include(template1)
      expect(results).not_to include(template2)
    end

    it 'returns paginated results' do
      results = CustomTemplate.search(page: 1, per_page: 1)
      expect(results.size).to eq(1)
    end
  end
end
