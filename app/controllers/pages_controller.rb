class PagesController < ApplicationController
  def home
    @featured_albums = Album.includes(:artist).order(release_date: :desc).limit(5) # Важные альбомы
    @popular_artists = Artist.joins(:albums).group(:id).order('count(albums.id) desc').limit(5) # Популярные артисты
    @recommended_tracks = Track.order(play_count: :desc).limit(10) # Рекомендации по трекам
    @news = News.order(created_at: :desc).limit(3) # Последние новости
    @stats = { total_paid: 1_410_000_000, last_year: 193_000_000 } # Данные статистики
  end
end
