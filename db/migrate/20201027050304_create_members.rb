class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.string :name
      t.string :discord
      t.references :group, null: false, foreign_key: true
      t.boolean :admin

      t.timestamps
    end
  end
end
