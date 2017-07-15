class ChangeUserCompanyAssociation < ActiveRecord::Migration[4.2]
  def up
    remove_column :companies, :owner_id
    add_column :users, :company_id, :integer, index: true
    add_column :users, :company_admin, :boolean, default: false
  end

  def down
    remove_column :users, :company_id
    remove_column :users, :company_admin
    add_column :companies, :owner_id, index: true
  end
end
