# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version "3.0.0"

* System dependencies
* rails, "~> 7.0.8"
* rspec-rails

* Database creation
* sqlite3,  "~> 1.4"

* How to run the test suite
* bundle exec rspec

* Create user with birthday other than current month.
   User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: '12/01/1991')

* with birthday in current month.
   User.create(name: 'Test User', email: 'test@example.com', country: 'USA', birthday: '12/06/1991')
  if user birthday comes in current month a coffee reward will be generate for them.


* Create trasaction (exchange) with amount less than 100 but for this trasaction, point will not be created

  Exchange.create(user: user, amount: 10, country: 'USA')

* Create trasaction (exchange) with amount more than 100 but for this trasaction, 100 points will be created

  Exchange.create(user: user, amount: 1000, country: 'USA')

* Create trasaction (exchange) with amount more than 100 in other country for this trasaction 200 points will be created

  Exchange.create(user: user, amount: 1000, country: 'UK')

* After user creation tier_type will be set "standard" initially
* if user collects point more than 1000 then it tier type will be change to 'gold' and if collects more that 5000 then it will become 'platinum'

* A 5% Cash Rebate reward is created for all users who have 10 or more transactions that have an amount > $100

* A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction

* Airport Lounge Access Reward will be given to a user becomes a gold tier customer

* Every calendar quarterly give 100 bonus points for every user spending greater than $2000 in that quarter


