class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :external_id
      t.string :url
      t.string :title
      t.string :location
      t.string :make_model
      t.text :description
      t.string :condition
      t.integer :year
      t.integer :size
      t.integer :price
      t.integer :price_last
      t.datetime :listed_at
      t.datetime :removed_at
      t.integer :days_active
      t.boolean :sold, :default => false

      t.timestamps
    end
  end
end
