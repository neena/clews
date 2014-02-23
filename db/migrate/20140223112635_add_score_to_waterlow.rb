class AddScoreToWaterlow < ActiveRecord::Migration
  def change
  	add_column :waterlows, :score, :integer
  end
end
