class CreateVipMeasurements < ActiveRecord::Migration
  def change
    create_table :vip_measurements do |t|
      t.belongs_to :observation
      t.integer :value
      t.datetime :recorded_at
      t.timestamps
    end
  end
end
