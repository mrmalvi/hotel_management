class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.references :imageable, polymorphic: true, null: false
      t.integer :position

      t.timestamps
    end
  end
end
