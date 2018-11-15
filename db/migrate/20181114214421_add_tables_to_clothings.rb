class AddTablesToClothings < ActiveRecord::Migration[5.0]
  def change
    add_column :clothings, :min_temp, :integer
    add_column :clothings, :max_temp, :integer
  end
end
