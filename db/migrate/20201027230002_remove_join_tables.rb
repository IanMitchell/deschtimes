class RemoveJoinTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :groups_shows
    drop_table :groups_users
  end
end
