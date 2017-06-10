class DropUserBalances < ActiveRecord::Migration[5.0]
  def up
    drop_table :user_balances
  end

  def down
    create_table :user_balances do |t|
      t.integer :balance_cents
      t.references :user, index: true

      t.timestamps
    end
  end
end
