class CreateRespirationRateMeasurements < ActiveRecord::Migration
  def change
    create_table :respiration_rate_measurements do |t|
			t.belongs_to :patient
			t.float :value
			t.datetime :datetime
			t.timestamps
    end
  end
end
