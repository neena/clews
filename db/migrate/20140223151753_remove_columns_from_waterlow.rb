class RemoveColumnsFromWaterlow < ActiveRecord::Migration
  def change
  	remove_column :waterlows, :skin_type_score
  	remove_column :waterlows, :bmi_score
  	remove_column :waterlows, :mobility_score
  	remove_column :waterlows, :continence_score
  end
end
