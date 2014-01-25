class RemoveWardFromPatient < ActiveRecord::Migration
  def change
  	remove_column :patients, :ward
  end
end
