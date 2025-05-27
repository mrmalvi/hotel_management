class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.references :room_type, foreign_key: true
      t.integer :hotel_id
      t.string :room_number
      t.integer :floor
      t.integer :price_per_night
      t.integer :capacity
      t.integer :max_adults
      t.integer :max_children
      t.string :status
      t.text :description
      t.timestamps
    end
  end
end
