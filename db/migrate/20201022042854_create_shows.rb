class CreateShows < ActiveRecord::Migration[6.0]
  def change
    create_table :shows do |t|
      t.string :name
      t.boolean :visible

      t.timestamps
    end
  end
end
