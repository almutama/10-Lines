class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
        # Comment properties.
        t.string :text

        # Comments belong to a user and a sketch.
        t.integer :user_id
        t.integer :sketch_id
      t.timestamps
    end
  end
end
