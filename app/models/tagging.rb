class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :taggable_type, presence: true
  validates :taggable_id, uniqueness: { scope: [:tag_id, :taggable_type] }
end
