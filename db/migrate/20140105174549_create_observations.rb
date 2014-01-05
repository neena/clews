class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.belongs_to :patient
      t.datetime :recorded_at
      t.timestamps
    end
  end
end
