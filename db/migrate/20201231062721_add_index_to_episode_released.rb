class AddIndexToEpisodeReleased < ActiveRecord::Migration[6.0]
  def change
    add_index :episodes, :released
  end
end
