class AddStatusToShow < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :status, :text
  end
end
