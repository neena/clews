class RemoveDateTimeFromMeasurement < ActiveRecord::Migration
  def change
  	remove_column :sys_bp_measurements, :datetime
  	remove_column :dia_bp_measurements, :datetime
  	remove_column :pulse_measurements, :datetime
  	remove_column :oxygen_sat_measurements, :datetime
  	remove_column :oxygen_supp_measurements, :datetime
  	remove_column :concious_measurements, :datetime
  	remove_column :respiration_rate_measurements, :datetime
  	remove_column :temperature_measurements, :datetime
  end
end
