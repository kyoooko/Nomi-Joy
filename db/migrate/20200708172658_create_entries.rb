class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.references :user, foreign_key: true, null: false
      t.references :room, foreign_key: true, null: false

      t.timestamps
    end
  end
end
