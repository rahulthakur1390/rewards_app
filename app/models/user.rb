class User < ApplicationRecord
  has_many :exchanges
  has_many :points
  has_many :rewards

  enum tier_type: { standard: 0, gold: 1, platinum: 2 }

  before_create :set_tier_type
  after_save :generate_airport_lounge_reward
  after_create :create_birthday_month_reward

  # A Free Coffee reward is given to all users during their birthday month
  # this method will be call from scheduler or job at the first day of every month to assign birthday Free Coffee reward to users
  def self.generate_birthday_month_reward
    month = sprintf('%02d', Date.today.month)
    users = User.where("strftime('%m', birthday) = ?", month)
    users.each do |user|
      next if user.rewards.where(reward_type: 'free_coffee').present?
      user.rewards.create(reward_type: 'free_coffee')
    end
  end

  # Every calendar quarterly give 100 bonus points for any user spending greater than $2000 in that quarter
  # this method will be call from scheduler or job at the end date of every qaurter of the year to assign bonus points to users
  def self.add_bonus_points
    end_date = Date.today
    start_date = end_date.beginning_of_quarter
    User.all.each do |user|
      spent_amount = user.exchanges.where('(Date(created_at) >= :start_date) AND (Date(created_at) <= :end_date)', start_date: start_date, end_date: end_date).pluck(:amount).sum
      user.points.create(quantity: 100, expire_at: Date.today + 1.year) if spent_amount > 2000
    end
  end

  private

  # A standard tier customer is an end user who accumulates 0 points
  def set_tier_type
    self.tier_type = 'standard'
  end

  # give airport lounge access reward when a user becomes a gold tier customer
  def generate_airport_lounge_reward
    return unless tier_type == 'gold' && rewards.where(reward_type: 'airport_lounge_access').blank?
    rewards.create(reward_type: 'airport_lounge_access')
  end

  # A Free Coffee reward is given to new user if their birthday comes in current month
  def create_birthday_month_reward
    return unless birthday.month == Date.today.month
    rewards.create(reward_type: 'free_coffee')
  end
end
