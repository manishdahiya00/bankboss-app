class Lead < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  scope :success, -> { where(status: "SUCCESS").order(created_at: :desc) }
  scope :processing, -> { where(status: "PROCESSING").order(created_at: :desc) }
  scope :rejected, -> { where(status: "REJECTED").order(created_at: :desc) }
end
