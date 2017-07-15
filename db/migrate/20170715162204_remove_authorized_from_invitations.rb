class RemoveAuthorizedFromInvitations < ActiveRecord::Migration[5.0]
  def change
    remove_column :invitations, :authorized, :boolean, default: false
  end
end
