class UpdateNewPointToUsers < ActiveRecord::Migration[7.1]
  def up
    change_column :users, :point, :integer, default: 0
  end
  def down 
    change_column :users, :point, :integer
  end
end
