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

  # validates :username, uniqueness: true, length: { maximum: 100 }
  # validates :role, inclusion: { in: %w[user artist admin] }
end
