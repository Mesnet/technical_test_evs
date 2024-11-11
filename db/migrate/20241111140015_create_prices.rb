class CreatePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :prices do |t|
      t.datetime :recorded_at, null: false
      t.decimal :value, null: false

      t.timestamps
    end

    add_index :prices, :recorded_at
  end
end
