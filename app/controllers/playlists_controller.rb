class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:show, :destroy]
  before_action :ensure_owner, only: [:destroy]

  def show
    @tracks = @playlist.tracks.includes(:album, :artist)
  end

  def new
    @playlist = current_user.playlists.new
  end

  def create
    @playlist = current_user.playlists.new(playlist_params)

    if @playlist.save
      redirect_to @playlist, notice: 'Playlist was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @playlist.destroy
    redirect_to profile_path, notice: 'Playlist was successfully deleted.'
  end

  def add_track
    @playlist = current_user.playlists.find(params[:id])
    @track = Track.find(params[:track_id])

    if @playlist.tracks << @track
      render json: { message: 'Track added to playlist successfully' }
    else
      render json: { error: 'Failed to add track to playlist' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'You are not authorized to modify this playlist' }, status: :unauthorized
  end

  def remove_track
    @playlist = Playlist.find(params[:id])
    
    if @playlist.user == current_user
      @track = Track.find(params[:track_id])
      if @playlist.tracks.delete(@track)
        render json: { message: 'Track removed from playlist successfully' }
      else
        render json: { error: 'Failed to remove track from playlist' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to modify this playlist' }, status: :unauthorized
    end
  end

  private

  def set_playlist
    @playlist = Playlist.includes(:tracks).find(params[:id])
  end

  def ensure_owner
    unless @playlist.user == current_user
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def playlist_params
    params.require(:playlist).permit(:title, :description)
  end
end
