class AddMissingIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :company_id
  end
end
