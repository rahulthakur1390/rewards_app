# spec/models/exchange_spec.rb

require 'rails_helper'

RSpec.describe Exchange, type: :model do
  let(:user) { User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: '12/01/1991') }

  describe '#generate_point' do
    context 'when the amount is greater than or equal to $100' do
      it 'generates points for the user' do
        exchange = Exchange.create(user: user, amount: 100, country: 'USA')
        expect(exchange.point).not_to be_nil
        expect(exchange.point.quantity).to eq(10)
      end

      it 'generates double points if the country is different from the user country' do
        exchange = Exchange.create(user: user, amount: 100, country: 'UK')
        expect(exchange.point.quantity).to eq(20)
      end
    end

    context 'when the amount is less than $100' do
      it 'does not generate points' do
        exchange = Exchange.create(user: user, amount: 50, country: 'USA')
        expect(exchange.point).to be_nil
      end
    end
  end

  describe '#generate_cash_rebate_reward' do
    context 'when the user has 10 or more transactions with amounts > $100' do
      it 'generates a cash rebate reward' do
        10.times { Exchange.create(user: user, amount: 101, country: 'USA') }
        expect(user.rewards.where(reward_type: 'cash_rebate')).not_to be_empty
      end
    end

    context 'when the user has less than 10 transactions with amounts > $100' do
      it 'does not generate a cash rebate reward' do
        Exchange.create(user: user, amount: 101, country: 'USA')
        expect(user.rewards.where(reward_type: 'cash_rebate')).to be_empty
      end
    end
  end

  describe '#generate_movie_ticket_reward' do
    # context 'when the user spends > $1000 within 60 days of their first transaction' do
    #   it 'generates a free movie ticket reward' do
    #     Exchange.create(user: user, amount: 600, country: 'USA', created_at: 1.month.ago)
    #     Exchange.create(user: user, amount: 400, country: 'USA', created_at: 15.days.ago)
    #     Exchange.create(user: user, amount: 400, country: 'USA', created_at: 1.days.ago)
    #     expect(user.rewards.where(reward_type: 'free_movie_tickets')).not_to be_empty
    #   end
    # end

    context 'when the user does not spend > $1000 within 60 days of their first transaction' do
      it 'does not generate a free movie ticket reward' do
        Exchange.create(user: user, amount: 500, country: 'USA', created_at: 50.days.ago)
        expect(user.rewards.where(reward_type: 'free_movie_tickets')).to be_empty
      end
    end
  end
end
