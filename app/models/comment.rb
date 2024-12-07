class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :comment, presence: true, length: { maximum: 1000 }
end
