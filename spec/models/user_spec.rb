require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_with_birthday_this_month) { User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 5.days )}
  let(:user_with_birthday_next_month) { User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 1.month )}

  describe '#generate_birthday_month_reward' do
		let(:user_with_birthday_this_month) { User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 5.days )}
		let(:user_with_birthday_next_month) { User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 1.month )}
    it 'generates a free coffee reward for users with birthdays in the current month' do
      
      User.generate_birthday_month_reward
      
      expect(user_with_birthday_this_month.rewards.where(reward_type: 'free_coffee')).to be_present
      expect(user_with_birthday_next_month.rewards.where(reward_type: 'free_coffee')).not_to be_present
    end
  end

  describe '#add_bonus_points' do
    it 'adds bonus points for users with spending greater than $2000 in the current quarter' do
      user = User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 5.days )
      Exchange.create(user: user, amount: 3000, country: 'USA') # Total spending: $3000
      User.add_bonus_points
      expect(user.points.pluck(:quantity).sum).to eq(400)
    end
  end

  describe '#set_tier_type' do
    it 'sets the tier type to standard before creation' do
      user = User.new(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 5.days )
      user.save

      expect(user.tier_type).to eq('standard')
    end
  end

  describe '#generate_airport_lounge_reward' do
	let(:user) { User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 5.days )}
    it 'generates an airport lounge access reward for gold tier users' do
			user.update(tier_type: 'gold')
      expect(user.rewards.where(reward_type: 'airport_lounge_access').count).to eq(1)
    end

    it 'does not generate an airport lounge access reward for non-gold tier users' do
      user.update(tier_type: 'platinum')
      expect(user.rewards.where(reward_type: 'airport_lounge_access')).to be_empty
    end
  end

  describe '#create_birthday_month_reward' do
    it 'creates a free coffee reward for a new user if their birthday is in the current month' do
      user_with_birthday_this_month = User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 5.days )
      user_with_birthday_next_month = User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: Date.today + 5.month )
      expect(user_with_birthday_this_month.rewards.where(reward_type: 'free_coffee')).to be_present
      expect(user_with_birthday_next_month.rewards.where(reward_type: 'free_coffee')).not_to be_present
    end
  end
end
