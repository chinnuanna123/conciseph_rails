# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should have_many(:family_members).class_name('User').with_foreign_key('family_head_id') }
    it { should have_many(:medications) }
    it { should have_many(:vital) }
    it { should have_many(:support_needs).dependent(:destroy) }
    it { should belong_to(:family_head).class_name('User').optional }
    it { should have_many(:trackings) }
    it { should have_many(:feedbacks) }
    it { should have_many(:payments) }
    it { should have_many(:user_actions).dependent(:destroy) }
    it { should have_one(:refer).with_foreign_key('owner_id') }
    it { should have_one(:member) }
  end

  describe 'validations' do
    # it { should validate_uniqueness_of(:phone) }
    # Other validations here
  end

  # describe 'enums' do
  #   it { should define_enum_for(:gender).with_values({ male: 111, female: 112, other: 113, NA: 114 }) }
  #   it { should define_enum_for(:ethnicity).with_values({ 'White' => 111, 'African Amercian' => 112, 'Latino' => 113, 'Asian' => 114, 'American Indian' => 115, 'Pacific Islander' => 116, 'NA' => 117 }) }
  #   it { should define_enum_for(:preferred_language).with_values({ 'english' => 111, 'spanish' => 112, 'NA' => 113 }) }
  #   # Additional enum tests
  # end

  describe 'callbacks' do
    context 'after create' do
      it 'calls assign_payments_to_user' do
        expect(user).to receive(:assign_payments_to_user)
        user.run_callbacks(:create)
      end

      it 'calls set_user_in_member' do
        expect(user).to receive(:set_user_in_member)
        user.run_callbacks(:create)
      end
    end

    context 'after save' do
      it 'calls create_user_actions if onboarding_steps_completed changes from false to true' do
        allow(user).to receive(:saved_change_to_onboarding_steps_completed?).and_return(true)
        allow(user).to receive(:changed_from_false_to_true?).and_return(true)
        expect(user).to receive(:create_user_actions)
        user.run_callbacks(:save)
      end
    end
  end

  describe '#generate_otp' do
    it 'generates a 6-digit OTP and sets the otp_number, otp_verified, and otp_validity fields' do
      allow(UserMailer).to receive_message_chain(:resend_otp, :deliver_now)
      user.generate_otp
      expect(user.otp_number.to_i).to be_between(100_000, 999_999)
      expect(user.otp_verified).to eq(false)
      expect(user.otp_validity).to be_within(1.second).of(DateTime.now + 1.minute)
      expect(UserMailer).to have_received(:resend_otp).with(user)
    end
  end

  describe '#current_plan' do
    let!(:refer) { create(:refer, code: 'ABC123', owner: user) }

    it 'returns a free plan when referred_by is present' do
      allow(user).to receive(:referred_by).and_return('ABC123')
      result = user.current_plan
      expect(result['user_id']).to eq(user.id)
      expect(result['amount']).to eq(0.0.to_d)
    end

    it 'returns a payment plan if no refer and active payment is present' do
      payment = create(:payment, user: user, active: true, amount: 100.0, expiry_date: Time.zone.now + 1.year)
      result = user.current_plan
      expect(result['amount']).to eq(payment.amount.to_s)
      expect(result['expiry_date']).to eq(payment.expiry_date.to_datetime.strftime('%s%3N').to_i)
    end

    #   it 'returns an empty hash if no refer or active payments are found' do
    #     allow(user).to receive(:referred_by).and_return(nil)
    #     expect(user.current_plan).to eq({})
    #   end
  end

  describe '#create_user_actions' do
    it 'calls CreateUserActionsNewUserJob when onboarding_steps_completed is true' do
      user.update(onboarding_steps_completed: true)
      expect(CreateUserActionsNewUserJob).to receive(:perform_later).with(user)
      user.create_user_actions
    end
  end

  # describe '#assign_payments_to_user' do
  #   it 'assigns payments to user when email matches' do
  #     payment = create(:payment, email: user.email, active: true)
  #     user.assign_payments_to_user
  #     payment.reload
  #     expect(payment.user_id).to eq(user.id)
  #   end
  # end

  describe '.search' do
    let(:code) { 'ABC123' }

    before do
      # Create some users with valid enum values
      create(:user, referred_by: code, name: 'John Doe', email: 'john@example.com', zip_code: '12345', gender: :male,
                    ethnicity: 'White', preferred_language: :english)
      create(:user, referred_by: code, name: 'Jane Smith', email: 'jane@example.com', zip_code: '67890',
                    gender: :female, ethnicity: 'Latino', preferred_language: :spanish)
      create(:user, referred_by: code, name: 'Johnny Depp', email: 'johnny@example.com', zip_code: '54321',
                    gender: :male, ethnicity: 'Asian', preferred_language: :english)
      create(:user, referred_by: 'XYZ456', name: 'Jack Black', email: 'jack@example.com', zip_code: '11111',
                    gender: :male, ethnicity: 'African Amercian', preferred_language: :english)
    end

    context 'when there are matching users' do
      let(:params) { { search: 'john' } }

      it 'returns users that match the search criteria and code' do
        result = User.search(params, code)
        expect(result.pluck(:name).sort).to eq(['John Doe', 'Johnny Depp'])
      end
    end

    context 'when there is a match on email' do
      let(:params) { { search: 'jane@example.com' } }

      it 'returns the user that matches the email' do
        result = User.search(params, code)
        expect(result.pluck(:name).sort).to eq(['Jane Smith'])
      end
    end

    context 'when there is a match on zip_code' do
      let(:params) { { search: '12345' } }

      it 'returns the user that matches the zip_code' do
        result = User.search(params, code)
        expect(result.pluck(:name)).to eq(['John Doe'])
      end
    end

    context 'when there is a match on gender' do
      let(:params) { { search: 'male' } }

      it 'returns users that match the gender' do
        result = User.search(params, code)
        expect(result.pluck(:name).sort).to eq(['John Doe', 'Johnny Depp', 'Jack Black'].sort)
      end
    end

    context 'when there is a match on ethnicity' do
      let(:params) { { search: 'Latino' } }

      it 'returns users that match the ethnicity' do
        result = User.search(params, code)
        expect(result.pluck(:name)).to eq(['Jane Smith'])
      end
    end

    context 'when there is a match on preferred_language' do
      let(:params) { { search: 'english' } }

      it 'returns users that match the preferred language' do
        result = User.search(params, code)
        expect(result.pluck(:name).sort).to eq(['Jack Black', 'John Doe', 'Johnny Depp'].sort)
      end
    end

    context 'when no users match' do
      let(:params) { { search: 'nonexistent' } }

      it 'returns an empty result' do
        result = User.search(params, code)
        expect(result).to be_empty
      end
    end

    context 'when params[:search] is nil' do
      let(:params) { { search: nil } }

      it 'returns users with the specified code and default filters' do
        result = User.search(params, code)
        expect(result.pluck(:name).sort).to eq(['Jane Smith', 'John Doe', 'Johnny Depp'])
      end
    end
  end
  # describe 'admin' do
  #   it 'user is admin' do
  #     let!(:user) {create(:user)}
  #     before do
  #       en

  #   end
  # end
  describe '#age' do
    context 'when reporting_age and age_updated_at are present' do
      before do
        user.reporting_age = 25
        user.age_updated_at = Time.zone.now - 2.years # Simulating age update 2 years ago
      end

      it 'calculates the correct age' do
        expect(user.age).to eq(27) # 25 + 2 = 27
      end
    end

    context 'when reporting_age is nil' do
      before do
        user.age_updated_at = Time.zone.now - 2.years
        user.reporting_age = nil
      end

      it 'returns nil' do
        expect(user.age).to be_nil
      end
    end

    context 'when age_updated_at is nil' do
      before do
        user.reporting_age = 25
        user.age_updated_at = nil
      end

      it 'returns nil' do
        expect(user.age).to be_nil
      end
    end
  end

  describe '#token_validation_response' do
    # let(:user) do
    #   create(:user,
    #     name: 'John Doe',
    #     email: 'john@example.com',
    #     tokens: { access: 'some_access_token', refresh: 'some_refresh_token' }, # Update to a hash
    #     created_at: Time.current,
    #     updated_at: Time.current,
    #     otp_verified: true,
    #     otp_validity: 30,
    #     otp_number: '123456'
    #   )
    # end

    it 'returns the correct attributes excluding specified fields' do
      expected_response = user.as_json(except: %i[tokens created_at updated_at otp_verified otp_validity otp_number])

      expect(user.token_validation_response).to eq(expected_response)
    end
  end

  describe '#current_admin' do
    context 'when user is an admin' do
      let(:admin_user) { create(:user, is_admin: true) }

      it 'returns true' do
        expect(admin_user.current_admin).to be_truthy
      end
    end

    context 'when user is not an admin' do
      let(:regular_user) { create(:user, is_admin: false) }

      it 'returns false' do
        expect(regular_user.current_admin).to be_falsey
      end
    end
  end
end
