class AddProjectUniqueIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :projects, [:group_id, :show_id], unique: true
  end
end
