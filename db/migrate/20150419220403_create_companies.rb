class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.references :owner, index: true

      t.timestamps null: false
    end
  end
end
