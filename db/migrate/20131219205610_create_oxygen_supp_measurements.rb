class CreateOxygenSuppMeasurements < ActiveRecord::Migration
  def change
    create_table :oxygen_supp_measurements do |t|
			t.belongs_to :patient
			t.boolean :value
			t.datetime :datetime
      t.timestamps
    end
  end
end
