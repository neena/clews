class AddEmailsToWard < ActiveRecord::Migration
  def change
    add_column :wards, :emails, :text #For serializing emails (array) on model
  end
end
