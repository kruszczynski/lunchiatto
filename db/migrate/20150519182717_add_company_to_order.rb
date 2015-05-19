class AddCompanyToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :company, index: true, foreign_key: true
  end
end
