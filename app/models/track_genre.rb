class TrackGenre < ApplicationRecord
  belongs_to :track
  belongs_to :genre

  validates :genre_id, uniqueness: { scope: :track_id, message: "track already associated with this genre" }
end
