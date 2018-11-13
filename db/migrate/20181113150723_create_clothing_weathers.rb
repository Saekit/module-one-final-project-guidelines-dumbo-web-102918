class CreateClothingWeathers < ActiveRecord::Migration[5.0]
  def change
    create_table :clothing_weathers do |t|
      t.integer :clothing_id
      t.integer :weather_id
    end
  end
end
