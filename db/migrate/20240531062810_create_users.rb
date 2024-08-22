class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :country
      t.integer :tier_type
      t.datetime :birthday

      t.timestamps
    end
  end
end
