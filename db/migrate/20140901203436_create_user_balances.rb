class CreateUserBalances < ActiveRecord::Migration[4.2]
  def change
    create_table :user_balances do |t|
      t.integer :balance_cents
      t.references :user, index: true

      t.timestamps
    end
  end
end
