class AddShippingToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :shipping_cents, :integer, default: 0
  end
end
