class CreateRoutes < ActiveRecord::Migration[8.1]
  def change
    create_table :routes do |t|
      t.string :route_number
      t.string :name

      t.timestamps
    end
    add_index :routes, :route_number, unique: true
  end
end
