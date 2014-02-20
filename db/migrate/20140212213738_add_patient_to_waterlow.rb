class AddPatientToWaterlow < ActiveRecord::Migration
  def change
  	add_reference :waterlows, :patient, index:true
  end
end
