class Artist < ApplicationRecord
  belongs_to :user
  has_many :albums, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :bio, length: { maximum: 1000 }, allow_blank: true
end
