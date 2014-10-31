class Reminder < ActiveRecord::Base
  belongs_to :patient
  belongs_to :creator, class_name: 'User'
  belongs_to :completor, class_name: 'User', foreign_key: 'completor_id'


  default_scope {where done: false}
  scope :ordered, lambda {order('due ASC')}
end
