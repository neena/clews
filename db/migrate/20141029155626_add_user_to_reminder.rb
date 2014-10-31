class AddUserToReminder < ActiveRecord::Migration
  def change
    add_reference :reminders, :creator
    add_reference :reminders, :completor
  end
end
