class RenamePriceToPriceCentsOnDish < ActiveRecord::Migration[4.2]
  def change
    rename_column :dishes, :price, :price_cents
  end
end
