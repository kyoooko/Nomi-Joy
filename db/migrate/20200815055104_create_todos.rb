class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :task, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
