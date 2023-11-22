class AddPointToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :point, :integer
    add_column :users, :checkin_date, :date
    add_column :users, :role, :integer, default: 0
  end
end
