class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :adress
      t.string :access
      t.float :latitude
      t.float :longitude
      t.string :url
      t.string :shop_image
      t.string :tel
      t.string :opentime
      t.string :holiday

      t.timestamps
    end
  end
end
