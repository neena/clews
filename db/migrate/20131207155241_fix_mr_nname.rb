class FixMrNname < ActiveRecord::Migration
  def change
  	rename_column :patients, :MRN, :mrn
  end
end
