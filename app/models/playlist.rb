class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks

  validates :title, presence: true, length: { maximum: 150 }
  validates :description, length: { maximum: 1000 }
end
