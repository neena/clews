class PatientsBelongToWard < ActiveRecord::Migration
  def change
	add_reference :patients, :ward, index:true
  end
end
