class ChangeAppetiteToString < ActiveRecord::Migration
  def change
  	remove_column :waterlows, :appetite
  	add_column :waterlows, :appetite, :string
  end
end
