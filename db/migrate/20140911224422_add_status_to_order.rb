class AddStatusToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :status, :integer, default: 0
  end
end
