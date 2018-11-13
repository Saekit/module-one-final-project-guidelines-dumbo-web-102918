class CreateClothings < ActiveRecord::Migration[5.0]
  def change
    create_table :clothings do |t|
      t.string :clothing_name
    end
  end
end
