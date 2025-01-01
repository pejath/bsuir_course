class Merchandise < ApplicationRecord
  belongs_to :artist
  belongs_to :album, optional: true
  has_many :merchandise_variants, dependent: :destroy
  has_many_attached :images

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :merchandise_type, presence: true, inclusion: { in: %w[vinyl cd cassette tshirt] }

  scope :vinyl, -> { where(merchandise_type: 'vinyl') }
  scope :cds, -> { where(merchandise_type: 'cd') }
  scope :cassettes, -> { where(merchandise_type: 'cassette') }
  scope :tshirts, -> { where(merchandise_type: 'tshirt') }
end 