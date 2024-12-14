class PagesController < ApplicationController
  def home
    @genres = Genre.all
    @query = params[:q]
    @albums = if @query.present?
      Album.includes(:artist, :tracks)
           .search_by_all(@query)
           .page(params[:page])
           .per(12)
    else
      Album.includes(:artist, :tracks)
           .order(created_at: :desc)
           .page(params[:page])
           .per(12)
    end
  end
end
