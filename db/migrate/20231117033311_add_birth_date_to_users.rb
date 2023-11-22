class AddBirthDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :birth_date, :date
    change_column_null :users, :phone, true
  end
end
