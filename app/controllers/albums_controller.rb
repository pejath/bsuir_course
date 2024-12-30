class AlbumsController < ApplicationController
  def index
  end

  def show
    @album = Album.includes(:artist, :tracks, :tags).find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def sidebar_info
    @album = Album.find(params[:id])
    sample_track = @album.tracks.first

    render json: {
      id: @album.id,
      title: @album.title,
      artist_name: @album.artist.name,
      cover_url: @album.cover_image.attached? ? 
        rails_blob_path(@album.cover_image) : 
        "https://tools-api.webcrumbs.org/image-placeholder/300/300/#{@album.tags.first&.name || 'abstract'}/#{@album.id}",
      sample_track_name: sample_track&.title || "No tracks available",
      audio_file_url: sample_track&.audio_file&.attached? ? rails_blob_path(sample_track.audio_file) : nil,
      is_favorited: current_user.favorited_album?(@album)
    }
  end
end
