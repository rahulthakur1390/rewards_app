class Exchange < ApplicationRecord
  belongs_to :user
  has_one :point

  validates :amount, :country, presence: true

  after_create :generate_point, :generate_cash_rebate_reward, :generate_movie_ticket_reward

  private

  #For every $100 the end user spends they receive 10 points
  #If the end user spends any amount of money in a foreign country they receive 2x the standard points
  def generate_point
    return unless amount >= 100
    quantity = country == user.country ? (amount / 10) : (amount / 10)*2
    new_point = build_point(user_id: user_id, quantity: quantity, expire_at: Date.today + 1.year)
    new_point.save
  end

  # A 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100
  def generate_cash_rebate_reward
    exchanges_count = user.exchanges.where("amount > ?", 100).count
    if exchanges_count >= 10
      rebate_amount = amount * 5 / 100.0

      user.rewards.create(reward_type: 'cash_rebate', amount: rebate_amount)
    end
  end

  # A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction
  def generate_movie_ticket_reward
    return if user.rewards.where(reward_type: 'free_movie_tickets').present?
    user_exchanges = Exchange.where(user_id: user_id)
    start_date = user_exchanges.first.created_at
    end_date = start_date + 60.days
    spent_amount = user_exchanges.where('(Date(created_at) >= :start_date) AND (Date(created_at) <= :end_date)', start_date: start_date, end_date: end_date).pluck(:amount).sum
    user.rewards.create(reward_type: 'free_movie_tickets') if spent_amount > 1000
  end
end
