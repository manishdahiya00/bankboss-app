class Offer < ApplicationRecord
  scope :active, -> { where(status: "active").order(created_at: :desc) }
end
