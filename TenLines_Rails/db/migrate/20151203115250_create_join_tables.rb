class CreateJoinTables < ActiveRecord::Migration
  def change
    # Sketches have many users.
    create_table :sketches_users do |t|
      t.integer :sketch_id
      t.integer :user_id
    end

    add_index :sketches_users, :sketch_id
    add_index :sketches_users, :user_id
  end
end
