class Video < ApplicationRecord
  scope :active, -> { where(status: true).order(created_at: :desc) }
end
