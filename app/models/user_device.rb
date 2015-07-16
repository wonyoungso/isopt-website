class UserDevice < ActiveRecord::Base
  belongs_to :user
  belongs_to :device
  belongs_to :event_isopt

  validates :user_id, :presence => true, :on => :update
  validates :device_id, :presence => true, :uniqueness => {scope: [:event_isopt_id]}, :on => :update
  validates :event_isopt_id, :presence => true, :uniqueness => {scope: [:device_id]}

  def conv_to_json
    json = {
      id: self.id,
      user: self.user.conv_to_json,
      event_isopt: self.event_isopt.conv_to_json
    }


    json[:device] = self.device.conv_to_json if self.device.present?
    json
  end
end
