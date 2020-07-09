class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :visiter, foreign_key: true, null: false
      t.references :visited, foreign_key: true, null: false
      t.integer :event_id
      t.integer :direct_message_id
      t.string :action, default: "", null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
