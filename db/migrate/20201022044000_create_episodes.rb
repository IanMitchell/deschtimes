class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.references :show, null: false, foreign_key: true
      t.datetime :air_date
      t.integer :number
      t.boolean :released

      t.timestamps
    end
  end
end
