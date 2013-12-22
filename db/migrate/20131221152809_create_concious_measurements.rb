class CreateConciousMeasurements < ActiveRecord::Migration
  def change
    create_table :concious_measurements do |t|
			t.belongs_to :patient
			t.string :value
			t.datetime :datetime
      t.timestamps
    end
  end
end
