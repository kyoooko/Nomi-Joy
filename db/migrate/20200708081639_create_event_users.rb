class CreateEventUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :event_users do |t|
      t.references :user_id, foreign_key: true, null: false
      t.references :event_id, foreign_key: true, null: false
      t.integer :fee
      t.boolean :fee_status, default: false, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
