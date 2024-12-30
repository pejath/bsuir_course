class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @album = Album.find(params[:album_id])
    @favorite = current_user.favorites.build(favoritable: @album)

    if @favorite.save
      render json: { message: 'Album added to favorites' }
    else
      render json: { error: 'Failed to add album to favorites' }, status: :unprocessable_entity
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(favoritable_type: 'Album', favoritable_id: params[:album_id])
    
    if @favorite&.destroy
      render json: { message: 'Album removed from favorites' }
    else
      render json: { error: 'Failed to remove album from favorites' }, status: :unprocessable_entity
    end
  end
end
