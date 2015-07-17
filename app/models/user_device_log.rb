class UserDeviceLog < ActiveRecord::Base
  belongs_to :user_device
  validates :user_device_id, :presence => true
end
