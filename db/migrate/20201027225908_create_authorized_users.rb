class CreateAuthorizedUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :authorized_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.boolean :owner, null: false, default: false

      t.timestamps
    end
  end
end
