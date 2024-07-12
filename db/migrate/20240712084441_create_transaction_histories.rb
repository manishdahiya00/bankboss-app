class CreateTransactionHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_histories do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.string :amount
      t.string :status,default: "PENDING"
      t.string :upi_id
      t.string :payout_id
      t.string :phone

      t.timestamps
    end
  end
end
