class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :firstname
      t.string :lastname
      t.string :icon

      # Users have many sketches.
      t.string :sketch_id

      t.timestamps
    end
  end
end
