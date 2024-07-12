class Payout < ApplicationRecord
  has_many :transaction_histories
end
