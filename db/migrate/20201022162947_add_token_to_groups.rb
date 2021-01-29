class AddTokenToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :token, :string, null: false
    add_index :groups, :token, unique: true
  end
end
