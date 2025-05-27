class CreateHotels < ActiveRecord::Migration[7.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :address
      t.text :description
      t.integer :star_rating
      t.references :platform, null: false, foreign_key: true

      t.timestamps
    end
  end
end
