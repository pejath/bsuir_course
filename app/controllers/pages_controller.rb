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
      format.turbo_stream do
        if params[:page].to_i > 1
          render turbo_stream: [
            turbo_stream.append("container", partial: "shared/album_card", collection: @albums, as: :album),
            turbo_stream.replace("load-more-button", 
              partial: "shared/load_more_button", 
              locals: { has_more: @albums.next_page.present? }
            )
          ]
        else
          render turbo_stream: turbo_stream.remove("albums-grid")
          # render turbo_stream: turbo_stream.replace("albums-grid", 
          #   partial: "shared/albums_grid", 
          #   locals: { albums: @albums }
          # )
        end
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
