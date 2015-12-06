class UpdateSketches < ActiveRecord::Migration
  def change
    add_column :sketches, :ispublic, :boolean
  end
end
