class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      # Line properties.
      t.string :color
      t.integer :width
      t.text :lines

      # Lines belong to a sketch.
      t.integer :sketch_id

      t.timestamps
    end
  end
end
