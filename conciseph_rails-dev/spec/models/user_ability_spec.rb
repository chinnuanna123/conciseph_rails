# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Abilities::UserAbility do
  let(:user) { create(:user) } # Assuming you have a factory for regular users
  let(:ability) { Abilities::UserAbility.new(user) }

  describe 'User abilities' do
    it 'does not have admin permissions by default' do
      expect(ability.can?(:admin_dashboard, User)).to be false
    end

    it 'cannot manage goals by default' do
      expect(ability.can?(:manage, Goal)).to be false
    end

    it 'cannot manage announcements by default' do
      expect(ability.can?(:manage, Announcement)).to be false
    end

    it 'cannot manage custom templates by default' do
      expect(ability.can?(:manage, CustomTemplate)).to be false
    end

    # Add more tests based on expected default permissions for regular users
  end
end
