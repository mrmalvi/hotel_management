class CreateGalleryImages < ActiveRecord::Migration[7.1]
  def change
    create_table :gallery_images do |t|
      t.references :room_type, null: false, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
