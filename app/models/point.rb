class Point < ApplicationRecord
  belongs_to :user
  belongs_to :exchange, optional: true

  after_create :check_for_reward, :manage_user_tier

  def points_in_current_cycle
    end_date = Date.today
    start_date = end_date - 60.days
    fetch_point_quantity(start_date, end_date)
  end

  def points_in_last_cycle
    end_date = Date.today - 61.days
    start_date = end_date - 120.days
    fetch_point_quantity(start_date, end_date)
  end

  def fetch_point_quantity(start_date, end_date)
    user.points.where('(Date(created_at) >= :start_date) AND (Date(created_at) <= :end_date)', start_date: start_date, end_date: end_date).pluck(:quantity).sum.to_i
  end

  #If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward
  def check_for_reward
    start_date = Date.today - 1.month
    end_date = Date.today
    points_quantity = user.points.where(expired: false).where('(Date(created_at) >= :start_date) AND (Date(created_at) <= :end_date)', start_date: start_date, end_date: end_date).pluck(:quantity).sum
    user.rewards.create(reward_type: 'free_coffee') if points_quantity >= 100 && user.rewards.where(reward_type: 'free_coffee').blank?
  end

  # A gold tier customer is an end user who accumulates 1000 points
  # A platinum tier customer is an end user who accumulates 5000 points
  def manage_user_tier
    # Loyalty tiers are calculated on the highest points in the last 2 cycles
    current_cycle_points = points_in_current_cycle
    last_cycle_points = points_in_last_cycle
    points_quantity = current_cycle_points > last_cycle_points ? current_cycle_points : last_cycle_points
    return unless points_quantity.present? && points_quantity >= 1000
    tier = if points_quantity >= 1000 && points_quantity < 5000
             'gold'
           elsif points_quantity >= 5000
             'platinum'
           end
    user.update(tier_type: tier)
  end

  # Points expire every year
  # this method will be call from scheduler or job every day to mark all points expire which created 1 year ago
  def self.set_expired
    Point.where(expired: false, expire_at: Date.today).update_all(expired: true)
  end
end
