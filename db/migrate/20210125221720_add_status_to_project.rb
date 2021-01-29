class AddStatusToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :status, :int, default: 0
    add_index :projects, :status
  end
end
