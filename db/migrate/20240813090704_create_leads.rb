class CreateLeads < ActiveRecord::Migration[7.1]
  def change
    create_table :leads do |t|
      t.string :pan_number
      t.string :mobile_number
      t.string :full_name
      t.string :email_address
      t.string :pincode
      t.string :offer_id
      t.string :user_id
      t.string :status, default: "PROCESSING"

      t.timestamps
    end
  end
end
