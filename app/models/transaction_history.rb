class TransactionHistory < ApplicationRecord
  belongs_to :user
  belongs_to :payout
end
