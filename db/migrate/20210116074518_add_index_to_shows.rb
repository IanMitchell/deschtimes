class AddIndexToShows < ActiveRecord::Migration[6.0]
  def change
    add_index :shows, :visible
    add_index :shows, :name
  end
end
