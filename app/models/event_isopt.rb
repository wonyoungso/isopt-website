class EventIsopt < ActiveRecord::Base
  
  has_many :user_devices
  has_many :users, :through => :user_devices, :source => :user
  has_many :devices, :through => :user_devices, :source => :device

  def conv_to_json
    {
      id: self.id,
      held_at: self.held_at.try("strftime", "%Y/%m/%d"),
      venue_name: self.venue_name
    }
  end

end
