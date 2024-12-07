class Genre < ApplicationRecord
  has_many :track_genres, dependent: :destroy
  has_many :tracks, through: :track_genres

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
end
