class Reminder < ActiveRecord::Base
  belongs_to :patient
  default_scope {where done: false}
  scope :ordered, lambda {order('due ASC')}
end
