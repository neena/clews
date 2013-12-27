class AddWardToPatient < ActiveRecord::Migration
  def change
  	add_column :patients, :ward, :integer
  end
end
