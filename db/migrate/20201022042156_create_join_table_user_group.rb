class CreateJoinTableUserGroup < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :groups do |t|
      t.index [:user_id, :group_id]
      t.index [:group_id, :user_id]
    end
  end
end
