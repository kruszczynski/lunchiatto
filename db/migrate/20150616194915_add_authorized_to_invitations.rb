class AddAuthorizedToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :authorized, :boolean, default: false
  end
end
