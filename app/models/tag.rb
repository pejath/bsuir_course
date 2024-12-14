class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :taggings, dependent: :destroy

  def self.popular
    joins(:taggings)
      .group(:id)
      .order('COUNT(taggings.id) DESC')
  end
end
