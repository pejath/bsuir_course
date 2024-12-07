class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true

  validates :favoritable_type, presence: true
  validates :favoritable_id, uniqueness: { scope: [:user_id, :favoritable_type] }
end
