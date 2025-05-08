# frozen_string_literal: true

module Abilities
  class UserAbility
    include CanCan::Ability

    def initialize(user, request = nil)
      @user = user
      @request = request
    end
  end
end
