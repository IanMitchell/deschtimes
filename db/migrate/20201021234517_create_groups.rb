class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :acronym, null: false, index: { unique: true }
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
