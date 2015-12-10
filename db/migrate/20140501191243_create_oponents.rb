class CreateOponents < ActiveRecord::Migration
  def change
    create_table :oponents do |t|
      t.integer :game_id

      t.timestamps
    end
  end
end
