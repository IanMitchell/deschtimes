class CreateStaff < ActiveRecord::Migration[6.0]
  def change
    create_table :staff do |t|
      t.references :member, null: false, foreign_key: true
      t.references :position, null: false, foreign_key: true
      t.references :episode, null: false, foreign_key: true
      t.boolean :finished, default: false

      t.timestamps
    end
  end
end
