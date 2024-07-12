class CreateOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :offers do |t|
      t.string :offer_name
      t.text :description
      t.string :status
      t.string :offer_type
      t.string :offer_rate
      t.string :offer_time
      t.string :offer_tags
      t.string :fee_charge
      t.string :offer_amount
      t.string :income_amount
      t.string :short_text
      t.string :priority
      t.string :yt_video_url
      t.string :icon_small_img_url
      t.string :banner_big_img_url
      t.string :action_url
      t.text :offer_terms
      t.text :offer_docs

      t.timestamps
    end
  end
end
