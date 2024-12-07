class Album < ApplicationRecord
  belongs_to :artist
  has_many :tracks, dependent: :destroy
  
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_one_attached :cover_image

  validates :title, presence: true, length: { maximum: 150 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :release_date, presence: true
end
