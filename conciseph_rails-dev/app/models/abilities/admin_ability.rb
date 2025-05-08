# frozen_string_literal: true

module Abilities
  class AdminAbility
    include CanCan::Ability

    def initialize(user, request = nil)
      @user = user
      @request = request

      can :admin_dashboard, User
      can :manage, Goal
      can :manage, Announcement
      can :manage, CustomTemplate
      can :manage, CareManagement
      can :manage, ChronicConditionManagementGoal
    end
  end
end
