class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.integer :user_id
      t.integer :reward_type
      t.integer :amount
      t.datetime :redeemed_at, default: nil

      t.timestamps
    end
  end
end
