class AddDishesCountToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :dishes_count, :integer, default: 0
  end
end
