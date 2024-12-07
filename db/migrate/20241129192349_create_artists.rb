class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :bio
      t.string :profile_img

      t.timestamps
    end
  end
end
