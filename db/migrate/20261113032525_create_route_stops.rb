class CreateRouteStops < ActiveRecord::Migration[8.1]
  def change
    create_table :route_stops do |t|
      t.references :route, null: false, foreign_key: true
      t.references :stop, null: false, foreign_key: true

      t.timestamps
    end
    add_index :route_stops, [:route_id, :stop_id], unique: true
  end
end