class AddAttrToOffers < ActiveRecord::Migration[7.1]
  def change
    add_column :offers, :features, :text
    add_column :offers, :fees_and_charges, :text
    add_column :offers, :target_audience, :text
    add_column :offers, :documents_required, :Text
    add_column :offers, :how_to_get_commission, :text
    add_column :offers, :lead_tracking_time, :text
  end
end
