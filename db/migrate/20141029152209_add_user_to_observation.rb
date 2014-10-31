class AddUserToObservation < ActiveRecord::Migration
  def change
    add_reference :observations, :user, index:true
  end
end
