class RemoveMeasurementTables < ActiveRecord::Migration
  def change
  	drop_table :concious_measurements
  	drop_table :dia_bp_measurements
  	drop_table :oxygen_sat_measurements
  	drop_table :oxygen_supp_measurements
  	drop_table :pulse_measurements
  	drop_table :respiration_rate_measurements
  	drop_table :sys_bp_measurements
  	drop_table :temperature_measurements
  	drop_table :vip_measurements
  end
end
