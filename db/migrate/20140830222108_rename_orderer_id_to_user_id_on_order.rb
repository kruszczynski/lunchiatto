class RenameOrdererIdToUserIdOnOrder < ActiveRecord::Migration[4.2]
  def change
    rename_column :orders, :orderer_id, :user_id
  end
end
