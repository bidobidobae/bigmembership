class RemoveMemberFromReports < ActiveRecord::Migration[7.1]
  def change
    remove_column :reports, :member
    add_column :reports, :partner, :string, null: false
  end
end
