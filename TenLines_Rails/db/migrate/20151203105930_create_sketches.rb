class CreateSketches < ActiveRecord::Migration
  def change
    create_table :sketches do |t|
      # Sketch properties.
      t.string :title
      t.string :url
      t.integer :upvotes

      # Sketches:
      # (1) have one creator
      # (2) belong to many users
      # (3) have many comments
      t.integer :creator_id
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end
  end
end
