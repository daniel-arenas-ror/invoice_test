class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.integer :speed
      t.integer :price

      t.timestamps
    end
  end
end
