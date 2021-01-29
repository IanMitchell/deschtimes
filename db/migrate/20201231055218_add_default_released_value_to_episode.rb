class AddDefaultReleasedValueToEpisode < ActiveRecord::Migration[6.0]
  def change
    change_column_default :episodes, :released, false
  end
end
