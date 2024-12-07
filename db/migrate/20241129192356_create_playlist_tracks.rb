class CreatePlaylistTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :playlist_tracks do |t|
      t.references :playlist, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.datetime :added_at

      t.timestamps
    end
  end
end
