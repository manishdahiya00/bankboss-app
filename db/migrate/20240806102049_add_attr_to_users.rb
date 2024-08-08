class AddAttrToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :mobile_number, :string
    add_column :users, :pincode, :string
    add_column :users, :gender, :string
  end
end
