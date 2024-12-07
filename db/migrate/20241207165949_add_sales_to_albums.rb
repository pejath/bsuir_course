class AddSalesToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :sales_count, :integer
  end
end
