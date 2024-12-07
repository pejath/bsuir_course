class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :purchase_date, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
