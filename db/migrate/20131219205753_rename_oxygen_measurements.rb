class RenameOxygenMeasurements < ActiveRecord::Migration
  def change
  	rename_table :oxygen_measurements, :oxygen_sat_measurements
  end
end
