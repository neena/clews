class RemoveMeasurementToPatientReferences < ActiveRecord::Migration
  def change
  	remove_column :sys_bp_measurements, :patient_id
  	remove_column :dia_bp_measurements, :patient_id
  	remove_column :pulse_measurements, :patient_id
  	remove_column :oxygen_sat_measurements, :patient_id
  	remove_column :oxygen_supp_measurements, :patient_id
  	remove_column :concious_measurements, :patient_id
  	remove_column :respiration_rate_measurements, :patient_id
  	remove_column :temperature_measurements, :patient_id
	end
end
