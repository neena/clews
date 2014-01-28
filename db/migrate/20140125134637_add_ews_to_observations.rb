class AddEwsToObservations < ActiveRecord::Migration
  def change
    add_column :observations, :score,  :integer, default: 0
    add_column :observations, :rating, :integer, default: 0
    add_column :observations, :status, :string,  default: 'incomplete'
  end
end
