class CreateMerchandises < ActiveRecord::Migration[7.0]
  def change
    create_table :merchandises do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :price, precision: 8, scale: 2, null: false
      t.string :merchandise_type, null: false
      t.references :artist, null: false, foreign_key: true
      t.references :album, foreign_key: true
      t.boolean :featured, default: false

      t.timestamps
    end

    add_index :merchandises, :merchandise_type
    add_index :merchandises, :featured
  end
end 