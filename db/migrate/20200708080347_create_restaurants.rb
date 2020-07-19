class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false
      t.string :address
      t.string :access
      t.string :url
      t.string :shop_image
      t.string :tel
      t.string :opentime
      t.string :holiday

      t.timestamps
    end
  end
end
