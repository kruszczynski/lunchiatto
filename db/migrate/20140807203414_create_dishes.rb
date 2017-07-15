class CreateDishes < ActiveRecord::Migration[4.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.decimal :cost, default: 0

      t.references :user, index: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
