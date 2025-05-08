# frozen_string_literal: true

module Launchable
  extend ActiveSupport::Concern

  def can_launch?
    if self.class != TimelyRecoveryGoal && (start_date.present? && end_date.present?)
      return ((start_date - 1.days)..end_date).cover?(Date.today)
    end

    status != 'Active'
  end
end
