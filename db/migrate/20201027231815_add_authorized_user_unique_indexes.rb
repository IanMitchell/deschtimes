class AddAuthorizedUserUniqueIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :authorized_users, [:group_id, :user_id], unique: true
  end
end
