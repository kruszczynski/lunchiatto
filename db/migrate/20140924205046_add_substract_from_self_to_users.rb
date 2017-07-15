class AddSubstractFromSelfToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :substract_from_self, :boolean, default: false
  end
end
