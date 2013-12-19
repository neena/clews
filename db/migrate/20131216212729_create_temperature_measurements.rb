class CreateTemperatureMeasurements < ActiveRecord::Migration
  def change
    create_table :temperature_measurements do |t|
			t.belongs_to :patient
			t.float :value
			t.datetime :datetime
      t.timestamps
    end
  end
end
