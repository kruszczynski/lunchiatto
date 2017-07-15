class RemoveColumnsFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :reset_password_sent_at, :string
    remove_column :users, :reset_password_token, :string
  end
end
