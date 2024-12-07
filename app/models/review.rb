class Review < ApplicationRecord
  belongs_to :user
  belongs_to :album

  validates :rating, presence: true, inclusion: { in: 1..5, message: "must be between 1 and 5" }
  validates :comment, length: { maximum: 1000 }, allow_blank: true
end
