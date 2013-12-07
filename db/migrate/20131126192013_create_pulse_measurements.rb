class CreatePulseMeasurements < ActiveRecord::Migration
  def change
    create_table :pulse_measurements do |t|
    	t.belongs_to :patient
    	t.float :value
    	t.datetime :datetime
    end
  end
end
