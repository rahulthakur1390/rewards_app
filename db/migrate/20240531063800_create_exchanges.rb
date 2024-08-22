class CreateExchanges < ActiveRecord::Migration[7.0]
  def change
    create_table :exchanges do |t|
      t.integer :user_id
      t.integer :amount
      t.string :country

      t.timestamps
    end
  end
end
