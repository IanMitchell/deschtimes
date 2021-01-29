class RemoveGuilds < ActiveRecord::Migration[6.0]
  def change
    drop_table :guilds
  end
end
