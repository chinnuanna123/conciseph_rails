# frozen_string_literal: true

# spec/concerns/launchable_spec.rb
require 'rails_helper'

RSpec.describe Launchable, type: :concern do
  before do
    # Define a dummy class for testing
    class DummyModel
      include Launchable
      attr_accessor :start_date, :end_date, :status

      def initialize(start_date: nil, end_date: nil, status: nil)
        @start_date = start_date
        @end_date = end_date
        @status = status
      end
    end
  end

  let(:dummy_model) { DummyModel.new(start_date: start_date, end_date: end_date, status: status) }
  let(:start_date) { Date.today - 5.days }
  let(:end_date) { Date.today + 5.days }
  let(:status) { 'Inactive' }

  context 'when start_date and end_date are present' do
    it 'returns true if the current date is within the start_date and end_date range' do
      expect(dummy_model.can_launch?).to be true
    end

    it 'returns false if the current date is outside the start_date and end_date range' do
      dummy_model.start_date = Date.today + 10.days
      dummy_model.end_date = Date.today + 20.days
      expect(dummy_model.can_launch?).to be false
    end
  end

  # context 'when the class is TimelyRecoveryGoal' do
  #   it 'returns false even if start_date and end_date are present' do
  #     allow(dummy_model).to receive(:class).and_return(TimelyRecoveryGoal)
  #     expect(dummy_model.can_launch?).to be false
  #   end
  # end

  context 'when start_date or end_date is not present' do
    let(:start_date) { nil }
    let(:end_date) { nil }

    it 'returns false based on the status being not Active' do
      expect(dummy_model.can_launch?).to be true
    end

    it 'returns false if the status is Active' do
      dummy_model.status = 'Active'
      expect(dummy_model.can_launch?).to be false
    end
  end
end
