class CreateWaterlowMeasurement < ActiveRecord::Migration
  def change
    create_table :waterlows do |t|
    	t.float :height
    	t.float :weight
    	t.float :bmi
    	t.float :bmi_score
    	t.string :skin_type
    	t.integer :skin_type_score
    	t.string :mobility
    	t.integer :mobility_score
    	t.string :continence
    	t.integer :continence_score
    	t.string :sex
    	t.integer :age
    	t.float :weight_loss
    	t.float :weight_loss_score
    	t.boolean :appetite
    	t.integer :nutrition_score
    	t.text :special_risks
    end
  end
end
