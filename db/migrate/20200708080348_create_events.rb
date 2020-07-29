class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :restaurant, foreign_key: true
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false
      t.datetime :date, null: false
      t.datetime :begin_time, null: false
      t.datetime :finish_time, null: false
      t.string :memo
      t.integer :progress_status, default: 0, null: false

      t.timestamps
    end
  end
end
