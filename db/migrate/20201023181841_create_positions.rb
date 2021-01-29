class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.string :acronym, null: false
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end

    add_index :positions, :name
    add_index :positions, :acronym
  end
end
