class AddStatusToTransfers < ActiveRecord::Migration[4.2]
  def change
    add_column :transfers, :status, :integer, default: 0
  end
end
