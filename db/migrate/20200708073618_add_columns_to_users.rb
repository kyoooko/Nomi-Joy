class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :belongs, :string
    add_column :users, :position, :string
    add_column :users, :image_id, :string
    add_column :users, :introduction, :string
    add_column :users, :nearest_station, :string
    add_column :users, :can_drink, :boolean
    add_column :users, :favolite, :string
    add_column :users, :unfavolite, :string
  end
end
