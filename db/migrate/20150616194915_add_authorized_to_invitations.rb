class AddAuthorizedToInvitations < ActiveRecord::Migration[4.2]
  def change
    add_column :invitations, :authorized, :boolean, default: false
  end
end
