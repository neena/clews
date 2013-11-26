class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :MRN
      t.string :given_name
      t.string :surname

      t.timestamps
    end
  end
end
