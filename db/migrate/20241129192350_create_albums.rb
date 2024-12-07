class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.references :artist, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :cover_img
      t.date :release_date

      t.timestamps
    end
  end
end
