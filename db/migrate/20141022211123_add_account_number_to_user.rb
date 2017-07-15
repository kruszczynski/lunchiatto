class AddAccountNumberToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :account_number, :string
  end
end
