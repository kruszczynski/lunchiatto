class AddFromToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :from, :string
  end
end
