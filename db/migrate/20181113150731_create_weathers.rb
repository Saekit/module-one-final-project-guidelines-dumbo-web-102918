class CreateWeathers < ActiveRecord::Migration[5.0]
  def change
    create_table :weathers do |t|
      t.integer :temperature
      t.string :weather_icon 
    end
  end
end
