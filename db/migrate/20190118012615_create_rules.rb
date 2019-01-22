class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :cidr, null: false
      t.string :permission, null: false
      t.references :user
      t.timestamps null: false
    end
  end
end
