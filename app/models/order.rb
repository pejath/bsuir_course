class Order < ApplicationRecord
  belongs_to :user
  belongs_to :purchasable, polymorphic: true

  validates :status, presence: true, inclusion: { in: %w[pending completed canceled] }
end
