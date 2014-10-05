class AddColumnsToObservation < ActiveRecord::Migration
  def change
  	add_column :observations, :concious, :string
  	add_column :observations, :dia_bp, :float
  	add_column :observations, :sys_bp, :float
  	add_column :observations, :oxygen_sat, :float
  	add_column :observations, :oxygen_supp, :boolean
  	add_column :observations, :pulse, :float
  	add_column :observations, :respiration_rate, :integer
  	add_column :observations, :temperature, :float
  	add_column :observations, :vip, :integer
  end
end
