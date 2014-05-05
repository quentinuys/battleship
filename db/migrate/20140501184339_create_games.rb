class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :battleship_id
      t.string :name
      t.string :email
      t.string :game_status
      t.string :prize

      t.timestamps
    end
  end
end
