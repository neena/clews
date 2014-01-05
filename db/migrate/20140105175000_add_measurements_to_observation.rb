class AddMeasurementsToObservation < ActiveRecord::Migration
  def change
  	add_reference :sys_bp_measurements, :observation, index:true
  	add_reference :dia_bp_measurements, :observation, index:true
  	add_reference :pulse_measurements, :observation, index:true
  	add_reference :oxygen_sat_measurements, :observation, index:true
  	add_reference :oxygen_supp_measurements, :observation, index:true
  	add_reference :concious_measurements, :observation, index:true
  	add_reference :respiration_rate_measurements, :observation, index:true
  	add_reference :temperature_measurements, :observation, index:true
  end
end
