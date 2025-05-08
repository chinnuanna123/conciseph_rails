# frozen_string_literal: true

# spec/api/v1_spec.rb

require 'rails_helper'

RSpec.describe Api::V1 do
  describe '.table_name_prefix' do
    it 'returns the correct table name prefix' do
      expect(described_class.table_name_prefix).to eq('api_v1_')
    end
  end
end
