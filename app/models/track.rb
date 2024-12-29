class Track < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_title_and_artist, against: :title,
                  associated_against: { album: :artist_name }

  belongs_to :album
  has_many :track_genres, dependent: :destroy
  has_many :genres, through: :track_genres
  has_many :comments, dependent: :destroy
  has_many :purchases
  has_one :artist, through: :album

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_one_attached :audio_file

  validates :title, presence: true, length: { maximum: 150 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  def increment_play_count
    self.increment!(:play_count)
  end

  def duration_formatted
    "#{duration / 60}:#{duration % 60}"
  end
end
