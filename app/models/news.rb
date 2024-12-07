class News < ApplicationRecord
  validates :title, presence: true, length: { maximum: 150 }
  validates :content, presence: true
end