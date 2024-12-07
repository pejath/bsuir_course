class AddStatsToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :play_count, :integer
    add_column :tracks, :download_count, :integer
  end
end
