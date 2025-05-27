class CreatePlatforms < ActiveRecord::Migration[7.0]
  def change
    create_table :platforms do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.boolean :enable_mail, default: false, null: false

      t.timestamps
    end

    add_index :platforms, :subdomain, unique: true
  end
end
