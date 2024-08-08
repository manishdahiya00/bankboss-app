class CreateKycDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :kyc_details do |t|
      t.string :user_id
      t.string :aadhar_number
      t.string :full_name
      t.string :address
      t.string :pan_number
      t.string :dob

      t.timestamps
    end
  end
end
