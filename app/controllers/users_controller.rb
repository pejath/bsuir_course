class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    @favorite_albums = current_user.favorite_albums.includes(:artist, :tags)
    @playlists = current_user.playlists.includes(:tracks)
  end
end 