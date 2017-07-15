class RenameCostToPriceOnDishes < ActiveRecord::Migration[4.2]
  def change
    rename_column :dishes, :cost, :price
  end
end
