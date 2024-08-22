class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.integer :user_id
      t.integer :exchange_id
      t.integer :quantity
      t.boolean :expired, default: false
      t.datetime :redeemed_at, default: nil
      t.datetime :expire_at

      t.timestamps
    end
  end
end
