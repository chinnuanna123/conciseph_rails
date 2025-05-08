# frozen_string_literal: true

require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      state = State.new(name: 'California')
      expect(state).to be_valid
    end
  end
end
