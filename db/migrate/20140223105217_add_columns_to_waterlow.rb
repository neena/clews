class AddColumnsToWaterlow < ActiveRecord::Migration
  def change
  	remove_column :waterlows, :sex
  	remove_column :waterlows, :age
  	remove_column :waterlows, :weight_loss
  	remove_column :waterlows, :weight_loss_score
  	add_column :patients, :sex, :string
  	add_column :patients, :dob, :datetime
  end
end
