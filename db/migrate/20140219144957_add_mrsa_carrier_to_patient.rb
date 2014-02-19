class AddMrsaCarrierToPatient < ActiveRecord::Migration
  def change
  	add_column :patients, :mrsa_carrier, :boolean
  end
end
