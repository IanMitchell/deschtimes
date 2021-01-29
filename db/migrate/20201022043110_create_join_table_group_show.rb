class CreateJoinTableGroupShow < ActiveRecord::Migration[6.0]
  def change
    create_join_table :groups, :shows do |t|
      t.index [:group_id, :show_id]
      t.index [:show_id, :group_id]
    end
  end
end
