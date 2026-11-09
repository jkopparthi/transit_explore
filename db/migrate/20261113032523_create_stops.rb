class CreateStops < ActiveRecord::Migration[8.1]
  def change
    create_table :stops do |t|
      t.references :street, null: false, foreign_key: true
      t.references :cross_street, null: true, foreign_key: { to_table: :streets }
      t.integer :stop_number
      t.string :name
      t.string :direction
      t.string :side
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.integer :departures_per_day
      t.boolean :has_shelter
      t.boolean :has_bench

      t.timestamps
    end
    add_index :stops, :stop_number, unique: true
  end
end