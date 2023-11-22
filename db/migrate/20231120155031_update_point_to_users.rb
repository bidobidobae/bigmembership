class UpdatePointToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :point, default: 0
  end
end
