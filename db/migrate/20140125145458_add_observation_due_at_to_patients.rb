class AddObservationDueAtToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :observation_due_at, :datetime
  end
end
