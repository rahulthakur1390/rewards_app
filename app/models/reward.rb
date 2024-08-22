class Reward < ApplicationRecord
  belongs_to :user

  enum reward_type: { free_coffee: 0, cash_rebate: 1, free_movie_tickets: 2, airport_lounge_access: 3 }
end
