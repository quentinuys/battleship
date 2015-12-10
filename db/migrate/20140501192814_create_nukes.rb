class CreateNukes < ActiveRecord::Migration
  def change
    create_table :nukes do |t|
      t.integer :x_position
      t.integer :y_position
      t.string :status
      t.integer :nukeable_id
      t.string :nukeable_type

      t.timestamps
    end
  end
end
