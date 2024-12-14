class PagesController < ApplicationController
  def home
    @genres = Tag.all
    @query = params[:q]
    @albums = filtering_albums
  end

  def filter_albums
    albums = Album.includes(:artist, :tracks, :tags)
    
    if params[:genres].present?
      tag_ids = params[:genres].split(',')
      albums = albums.joins(:tags).where(tags: { id: tag_ids }).distinct
    end
    
    if @query.present?
      albums = albums.search_by_all(@query)
    end
    
    @albums = albums.order(created_at: :desc).page(params[:page]).per(12)
    
    respond_to do |format|
      # format.html { render partial: "shared/albums_grid", locals: { albums: @albums } }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("albums-grid", 
          partial: "shared/albums_grid", 
          locals: { albums: @albums }
        )
      end
    end
  end

  private

  def filtering_albums
    Album.includes(:artist, :tracks, :tags)
         .order(created_at: :desc)
         .page(params[:page])
         .per(12)
  end
end
