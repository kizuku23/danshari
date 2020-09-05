class ChangeColumnToAllowNull < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :gender, :integer, null: true
    change_column :users, :age, :integer, null: true
    change_column :users, :status, :integer, null: true
    change_column :users, :layout, :integer, null: true
    change_column :users, :area, :integer, null: true
    change_column :users, :profile_image_id, :string, null: true
  end

  def down
    change_column :users, :gender, :integer, null: false
    change_column :users, :age, :integer, null: false
    change_column :users, :status, :integer, null: false
    change_column :users, :layout, :integer, null: false
    change_column :users, :area, :integer, null: false
    change_column :users, :profile_image_id, :string, null: false
  end
end
