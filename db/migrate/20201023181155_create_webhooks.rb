class CreateWebhooks < ActiveRecord::Migration[6.0]
  def change
    create_table :webhooks do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :platform, default: 0
      t.references :group

      t.timestamps
    end
  end
end
