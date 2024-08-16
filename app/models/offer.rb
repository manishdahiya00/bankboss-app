class Offer < ApplicationRecord
  has_many :leads, dependent: :destroy
  scope :active, -> { where(status: "active").order(created_at: :desc) }
end
