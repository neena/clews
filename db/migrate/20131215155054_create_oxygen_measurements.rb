class CreateOxygenMeasurements < ActiveRecord::Migration
  def change
    create_table :oxygen_measurements do |t|
		t.belongs_to :patient
		t.float :value
		t.datetime :datetime
		t.timestamps
    end
  end
end
