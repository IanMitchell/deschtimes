class MakeUserNameUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :name, unique: true
  end
end
