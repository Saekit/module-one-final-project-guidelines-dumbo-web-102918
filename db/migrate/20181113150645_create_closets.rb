class CreateClosets < ActiveRecord::Migration[5.0]
  def change
    create_table :closets do |t|
      t.integer :user_id
      t.integer :clothing_id
    end
  end
end
