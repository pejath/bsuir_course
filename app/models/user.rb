class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :artists
  has_many :purchases
  has_many :favorites
  has_many :favorite_tracks, through: :favorites, source: :favoritable, source_type: 'Track'
  has_many :favorite_albums, through: :favorites, source: :favoritable, source_type: 'Album'
  has_many :playlists
  has_many :reviews
  has_many :comments
  has_many :notifications
  has_many :subscriptions
  has_one_attached :avatar
  validates :username, presence: true, 
                      uniqueness: { case_sensitive: false },
                      format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers and underscores" },
                      length: { minimum: 3, maximum: 30 }
  # validates :role, inclusion: { in: %w[user artist admin] }

  def favorited_album?(album)
    favorite_albums.include?(album)
  end
end
