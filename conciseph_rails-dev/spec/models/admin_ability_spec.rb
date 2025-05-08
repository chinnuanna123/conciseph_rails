# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Abilities::AdminAbility do
  let(:admin_user) { create(:user, is_admin: true) } # Assuming you have a factory for admin users
  let(:ability) { Abilities::AdminAbility.new(admin_user) }

  describe 'Admin abilities' do
    it 'allows access to admin dashboard' do
      expect(ability.can?(:admin_dashboard, User)).to be true
    end

    it 'allows management of goals' do
      expect(ability.can?(:manage, Goal)).to be true
    end

    it 'allows management of announcements' do
      expect(ability.can?(:manage, Announcement)).to be true
    end

    it 'allows management of custom templates' do
      expect(ability.can?(:manage, CustomTemplate)).to be true
    end

    # it 'does not allow access to unauthorized actions' do
    #   # Assuming Post is not supposed to be managed by the admin user
    #   expect(ability.can?(:manage, Post)).to be false  # Replace Post with any unauthorized model
    # end
  end
end
