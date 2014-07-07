class AddDoneToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :done, :boolean
  end
end
