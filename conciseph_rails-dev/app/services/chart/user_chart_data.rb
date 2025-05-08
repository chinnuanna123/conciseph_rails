# frozen_string_literal: true

module Chart
  class UserChartData
    attr_reader :total_family_heads, :initial_query, :current_user

    def initialize(current_user)
      @current_user = current_user
      @total_family_heads = 0

      if current_user.refer.present?
        @initial_query = User.where('is_admin = ? and super_admin = ? and referred_by = ? and otp_verified = ?', false, false,
          current_user.refer.code, true)
        @total_family_heads = initial_query.where(family_head: nil).count
      end
      
    end

    def call
      {
        enrollment: enrollment,
        preferred_language: preferred_language,
        cultural_preferrences: cultural_preferrences,
        age_group: age_group,
        support_needs: support_needs
      }
    end

    private

    def enrollment
      enrollment_count = User.where(
        'is_admin = ? and super_admin = ? and last_seen_at >= ? and referred_by = ? and otp_verified = ?', false, false, Time.zone.now.beginning_of_month, current_user.refer.code, true
      ).count
  
      result_hash = {
        'Enrolled' => total_family_heads - enrollment_count,
        'Not enrolled' => 0
      }
      {
        labels: result_hash.keys,
        data: result_hash.values
      }
    end

    def preferred_language
      language_counts = initial_query.group(:preferred_language).count
      result_hash = replace_nil_with_na(language_counts)

      {
        labels: result_hash.keys.map(&:titleize),
        data: result_hash.values
      }
    end

    def cultural_preferrences
      ethnicity_counts = initial_query.group(:ethnicity).count
      result_hash = replace_nil_with_na(ethnicity_counts)

      {
        labels: result_hash.keys,
        data: result_hash.values
      }
    end

    def age_group
      result_hash = {
        '0-18' => 0,
        '18-64' => 0,
        '64-100' => 0,
        'Not Reported' => 0
      }
      age_group_hash = initial_query
                       .group(age_group_query).count
      result_hash.merge!(age_group_hash)
      {
        labels: result_hash.keys,
        data: result_hash.values
      }
    end

    def age_group_query
      "CASE
        WHEN (users.reporting_age + (DATE_PART('year', CURRENT_DATE) - DATE_PART('year', age_updated_at))) <= 18 THEN '0-18'
        WHEN (users.reporting_age + (DATE_PART('year', CURRENT_DATE) - DATE_PART('year', age_updated_at))) <= 64 THEN '18-64'
        WHEN (users.reporting_age + (DATE_PART('year', CURRENT_DATE) - DATE_PART('year', age_updated_at))) <= 100 THEN '64-100'
        ELSE 'Not Reported'
        END"
    end

    def support_needs
      result_hash = SupportNeed.codes.map { |x, _v| [x, 0] }.to_h
      support_need_hash = SupportNeed.joins(:user).where(users: { referred_by: current_user.refer.code }).group('code').count
      na_count = User.count - SupportNeed.where.not(code: 0).distinct.count(:user_id)
      na_hash = { SupportNeed.codes.key(0) => na_count }
      result_hash.merge!(support_need_hash).merge!(na_hash)
      {
        labels: result_hash.keys,
        data: result_hash.values
      }
    end

    def replace_nil_with_na(hash)
      if hash.key?(nil)
        hash['Not Reported'] = hash.fetch(nil) + (hash['NA'] || 0)
        hash.delete(nil)
      end

      hash
    end
  end
end
