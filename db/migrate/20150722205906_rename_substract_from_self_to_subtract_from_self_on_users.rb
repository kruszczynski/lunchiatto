class RenameSubstractFromSelfToSubtractFromSelfOnUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :substract_from_self, :subtract_from_self
    end
  end
end
