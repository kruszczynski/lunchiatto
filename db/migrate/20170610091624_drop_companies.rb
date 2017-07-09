class DropCompanies < ActiveRecord::Migration[5.0]
  def up
    remove_column :invitations, :company_id
    remove_column :users, :company_id
    remove_column :users, :company_admin
    remove_column :orders, :company_id

    drop_table :companies
  end

  def down
    create_table :companies do |t|
      t.string :name
      t.timestamps null: false
    end

    add_column(
      :invitations, :company_id, :integer, index: true, foreign_key: true)
    add_column :users, :company_id, :integer, index: true, foreign_key: true
    add_column :users, :company_admin, :boolean, default: false
    add_column :orders, :company_id, :integer, index: true, foreign_key: true

  end
end
