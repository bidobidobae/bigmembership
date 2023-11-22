class AddFirstNameAndLastNameToReports < ActiveRecord::Migration[7.1]
  def change
    add_column :reports, :name, :string, null: false
  end
end
