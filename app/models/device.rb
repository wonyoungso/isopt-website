class Device < ActiveRecord::Base
  validates :sim_card_id, :presence => true, :uniqueness => true
  validates :human_id, :presence => true, :uniqueness => true

  has_many :user_devices
  has_many :users, :through => :user_devices, :source => :user
  has_many :event_isopts, :through => :user_devices, :source => :event_isopt




  def conv_to_json
    {
      id: self.id,
      sim_card_id: self.sim_card_id,
      human_id: self.human_id
    }

    #{"state" => @state, "sim_id" => @sim_id, "start_time" => @start_time, "minute_in_ms" => @minute_in_ms, "personal_time" => self.personal_time}.to_s
  end



  def current_user_device
    self.user_devices.joins(:event_isopt).where("event_isopts.is_activated = ? AND event_isopts.is_ended IS NULL", true).first
  end

  def current_user_name
    if self.current_user_device.present?
      self.current_user_device.user.fullname
    else
      "None"
    end
  end

  def current_event_isopt_name
    if self.current_user_device.present?
      self.current_user_device.event_isopt.held_at.strftime("%Y/%m/%d %H:%M")
    else
      "None"
    end
  end

end
