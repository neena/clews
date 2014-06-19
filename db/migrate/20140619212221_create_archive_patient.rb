class CreateArchivePatient < ActiveRecord::Migration
  def change
    create_table :archive_patients do |t|
		t.string   :mrn
		t.string   :given_name
		t.string   :surname
		t.datetime :observation_due_at
		t.boolean  :mrsa_carrier
		t.string   :sex
		t.datetime :dob
		t.timestamps
    end
  end
end
