class ChangePriceCentsToIntegerOnDish < ActiveRecord::Migration[4.2]
  def up
    change_column :dishes, :price_cents, :integer
  end

  def down
    change_column :dishes, :price_cents, :decimal
  end
end
