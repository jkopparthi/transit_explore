class CreateStreets < ActiveRecord::Migration[8.1]
  def change
    create_table :streets do |t|
      t.integer :transit_id
      t.string :name
      t.string :street_type

      t.timestamps
    end
    add_index :streets, :transit_id, unique: true
  end
end
