class RemoveSubtractFromSelfFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :subtract_from_self, :boolean, default: false
  end
end
