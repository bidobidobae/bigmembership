class RemoveCheckinDateFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :checkin_date
  end
end
