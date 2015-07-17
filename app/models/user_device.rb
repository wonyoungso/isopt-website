class UserDevice < ActiveRecord::Base
  belongs_to :user
  belongs_to :device
  belongs_to :event_isopt

  validates :device_id, :uniqueness => {scope: :event_isopt_id, allow_nil: true}
  # validates :event_isopt_id, :uniqueness => {scope: :device_id, allow_nil: true}
  has_many :user_device_logs

  STATES = [:state_inactive, :state_waiting_for_minute, :state_active]

  def conv_to_json
    json = {
      id: self.id,
      user: self.user.conv_to_json,
      event_isopt: self.event_isopt.conv_to_json
    }


    json[:device] = self.device.conv_to_json if self.device.present?
    json
  end

  def state
    if self.event_isopt.is_activated?
      if self.user.is_initialized?
        :state_active
      else
        :state_waiting_for_minute
      end
    else
      :state_inactive
    end
  end

  def set_minute(mms)
    if self.state == :state_waiting_for_minute
      user = self.user
      user.init_time = mms
      user.is_initialized = true
      user.init_at = DateTime.now

      user.save
    else
      false
    end
  end

  def add_moment(mms)
    if self.state == :state_active

      moment_record = MomentRecord.new
      moment_record.user = self.user
      moment_record.submitted_at = DateTime.now
      moment_record.milliseconds = mms

      moment_record.save

    else
      false
    end
  end

end
