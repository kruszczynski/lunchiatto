class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :payer, index: true, references: :users
      t.integer :balance_cents
      t.timestamps
    end
    add_foreign_key :payments, :users, column: :payer_id
  end
end
