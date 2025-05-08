# frozen_string_literal: true

class User < ApplicationRecord
  has_many :family_members, class_name: 'User', foreign_key: 'family_head_id'
  has_many :medications
  has_many :vital
  has_many :support_needs, dependent: :destroy
  belongs_to :family_head, class_name: 'User', optional: true
  # accepts_nested_attributes_for :family_members, allow_destroy: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  # validates :phone, uniqueness: true
  has_many :trackings
  has_many :feedbacks
  has_many :payments
  # has_many :user_goals
  has_many :user_actions, dependent: :destroy
  has_one :refer, foreign_key: 'owner_id'
  has_one :member
  # after_save :generate_otp
  attr_accessor :is_new_user

  after_create :assign_payments_to_user

  after_save :create_user_actions, if: -> { saved_change_to_onboarding_steps_completed? && changed_from_false_to_true? }
  after_create :set_user_in_member

  # TODO: sachin- create enum for gender, ethnicity, preferred_language(english,spanish),blood_group here --done
  enum gender: {
    'male': 111,
    'female': 112,
    'other': 113,
    'NA': 114
  }, _prefix: true
  enum gender_on_birth_certificates: {
    'male': 111,
    'female': 112,
    'other': 113,
    'NA': 114
  }, _prefix: true
  enum ethnicity: {
    'White': 111,
    'African Amercian': 112,
    'Latino': 113,
    'Asian': 114,
    'American Indian': 115,
    'Pacific Islander': 116,
    'NA': 117
  }, _prefix: true
  enum preferred_language: {
    'english': 111,
    'spanish': 112,
    'NA': 113
  }, _prefix: true
  enum blood_group: {
    'A+': 111,
    'A-': 112,
    'B+': 113,
    'B-': 114,
    'O+': 115,
    'O-': 116,
    'AB+': 117,
    'AB-': 118,
    'NA': 119
  }, _prefix: true
  enum speciality: {
    'OB GYN': 111,
    'Primary Care': 112,
    'Psychiatric': 113,
    'NA': 114

  }, _prefix: true
  enum medication_adhere_status: {
    'Not Started': 0,
    'Adherence': 1,
    'Non Adherence': 2
  }, _prefix: true

  def token_validation_response
    as_json(except: %i[tokens created_at updated_at otp_verified otp_validity otp_number])
  end

  def generate_otp
    update_column(:otp_verified, false)

    random_number = if email == "app_test@conciseph.com"
      141124.to_s
    else
      rand(100_000..999_999).to_s
    end
  end

  def save_and_send_generated_otp
    otp = generate_otp
    redis = RedisStorage.new
    redis.setex_with_expiry(self.id, otp, 5.minutes)
    SendOtpJob.perform_later(self, otp)
  end

  def current_admin
    is_admin
  end

  def current_plan
    refer = Refer.find_by_code(referred_by)
    if refer.present?
      {
        'user_id' => id,
        'amount' => 0.0.to_d,
        'currency' => '',
        'expiry_date' => (Time.zone.now + 100.years).strftime('%s%3N').to_i,
        'purchase_id' => '',
        'order_id' => '',
        'sku_code' => '',
        'purchase_type' => ''

      }
    else
      payment = payments.where(active: true).first&.as_json
      if payment.present?
        payment.slice('amount', 'currency', 'purchase_id', 'order_id', 'sku_code',
                      'purchase_type').merge({ 'expiry_date' => payment['expiry_date'].to_datetime.strftime('%s%3N').to_i })
      else
        {}
      end
    end
  end
  # def active_for_authentication?(check_for_admin=true)
  #   (check_for_admin) ? super && self.current_admin : super # i.e. super && self.is_active
  # end

  # def inactive_message
  #   "Sorry, not a valid user to sign in"
  # end

  def assign_payments_to_user
    payments = Payment.where(email: email, active: true)
    payments.update_all(user_id: id) if payments.present?
  end

  def self.search(params, code)
    query = 'referred_by = :code AND '
    search_obj = {
      code: code
    }

    query += 'is_admin = :is_admin and super_admin = :super_admin'

    search_obj.merge!({ is_admin: false, super_admin: false })

    if params[:search].present?
      query = "#{query} AND " if query.present?
      query = "#{query}lower(name) like lower(:search) or lower(email) like lower(:search) or zip_code like :search "
      search_obj[:search] = "%#{params[:search]}%"

      if User.genders[params[:search].downcase].present?
        query = "#{query} or gender = :gender"
        search_obj[:gender] = User.genders[params[:search].downcase].to_s
      end

      if User.ethnicities[params[:search].titleize].present?
        query = "#{query} or ethnicity = :ethnicity"
        search_obj[:ethnicity] = User.ethnicities[params[:search].titleize].to_s
      end

      if User.preferred_languages[params[:search].downcase].present?
        query = "#{query} or preferred_language = :preferred_language"
        search_obj[:preferred_language] = User.preferred_languages[params[:search].downcase].to_s
      end

    end
    User.where(query, search_obj)
  end

  def age
    return unless reporting_age.present? && age_updated_at.present?

    reporting_age + (Time.zone.now.year - age_updated_at.year)
  end

  def reporting_date_age
    return unless birth_date.present?

    created_at.year - birth_date.year
  end

  def changed_from_false_to_true?
    !onboarding_steps_completed_before_last_save && onboarding_steps_completed?
  end

  def create_user_actions
    CreateUserActionsNewUserJob.perform_later(self) if onboarding_steps_completed
  end

  def set_user_in_member
    member = Member.find_by(email: email)
    member.update(user_id: id) if member.present?
  end
end
