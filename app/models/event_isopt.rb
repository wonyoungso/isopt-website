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

  def self.no_other_event_running?
    EventIsopt.where(is_activated: true, is_ended: false).count == 0
  end

  def reset_all_records!
    self.users.each do |user|
      user.init_time = nil
      user.is_initialized = false
      user.init_at = nil
      user.save 

      user.moment_records.destroy_all
    end

  end


end
