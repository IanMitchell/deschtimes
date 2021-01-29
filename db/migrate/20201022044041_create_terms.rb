class CreateTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :terms do |t|
      t.references :show, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
