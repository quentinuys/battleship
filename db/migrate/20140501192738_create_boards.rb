class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :height
      t.integer :width
      t.integer :grid_width
      t.integer :grid_height
      t.integer :boardable_id
      t.string :boardable_type

      t.timestamps
    end
  end
end
