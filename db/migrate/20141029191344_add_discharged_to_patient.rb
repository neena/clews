class AddDischargedToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :discharged, :boolean, :default => false
  end
end
