require 'rails_helper'

RSpec.describe Point, type: :model do
  let(:user) { User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: '12/01/1991') }

  describe '#check_points' do
    let(:point) { Point.create(user: user, quantity: 50, created_at: Date.today) }
    context '#points_in_current_cycle' do
      it 'returns points within the current cycle' do
        expect(point.points_in_current_cycle).to eq(50)
      end
    end

    describe '#points_in_last_cycle' do
      it 'returns points within the last cycle' do
        expect(point.points_in_last_cycle).to eq(0)
      end
    end

    describe '#fetch_point_quantity' do
      it 'returns sum of points within the given date range' do
        expect(point.fetch_point_quantity(Date.today - 60.days, Date.today)).to eq(50)
      end
    end
  end

  describe '#check_for_reward' do
    it 'creates a reward for the user if points quantity is >= 100' do
      user.points.create(quantity: 100, created_at: Date.today - 15.days)
      expect(user.rewards.where(reward_type: 'free_coffee')).not_to be_empty
    end

    it 'does not create a reward if points quantity is < 100' do
      user.points.create(quantity: 50, created_at: Date.today - 15.days)
      expect(user.rewards.where(reward_type: 'free_coffee')).to be_empty
    end
  end


  describe '#manage_user_tier' do
    let(:point) { Point.create(user: user, quantity: 50, created_at: Date.today) }
    it 'updates user tier to gold if points quantity >= 1000' do
      user.points.create(quantity: 1000, created_at: Date.today - 30.days)
      user.reload
      expect(user.tier_type).to eq('gold')
    end

    it 'updates user tier to platinum if points quantity >= 5000' do
      user.points.create(quantity: 5000, created_at: Date.today - 10.days)
      user.reload
      expect(user.tier_type).to eq('platinum')
    end
  end

  describe '.set_expired' do
    let(:point) { Point.create(user: user, quantity: 50, created_at: Date.today) }
    it 'does not mark recent points as expired' do
      point.update(created_at: Date.today - 6.months)
      Point.set_expired
      point.reload
      expect(point.expired).to eq(false)
    end
  end
end
