class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :title
      t.references :patient, index: true
      t.string :text
      t.datetime :due

      t.timestamps
    end
  end
end
