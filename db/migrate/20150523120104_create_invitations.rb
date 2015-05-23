class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :company, index: true, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
