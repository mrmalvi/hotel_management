class CreateSeizures < ActiveRecord::Migration[7.1]
  def change
    create_table :seizures do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.datetime :seized_at, null: false
      t.datetime :released_at
      t.datetime :release_deadline, null: false
      t.decimal :total_overdue_amount, precision: 10, scale: 2, null: false
      t.string :status, default: 'active', null: false
      t.text :notes

      t.timestamps
    end

    add_index :seizures, :status
    add_index :seizures, :seized_at
    add_index :seizures, :release_deadline
  end
end 