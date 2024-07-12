class CreatePayouts < ActiveRecord::Migration[7.1]
  def change
    create_table :payouts do |t|
      t.string :title
      t.string :img_url
      t.string :reward
      t.string :redeem_limit
      t.string :reward_type

      t.timestamps
    end
  end
end
