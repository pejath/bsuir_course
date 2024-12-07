class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true, length: { maximum: 1000 }
  validates :read, inclusion: { in: [true, false] }
end
