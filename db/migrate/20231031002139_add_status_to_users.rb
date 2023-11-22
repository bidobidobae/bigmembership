class AddStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status, :boolean, default: false
  end
end
