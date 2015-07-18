class User < ActiveRecord::Base
  has_secure_password

  has_many :moment_records
  attr_accessor :updating_password


  validates :username, presence: {message: "Please enter a username"},
                       uniqueness: {message: "This username already exists"},
                       exclusion: { in: %w(. ,), message: "No dots and commas." }



  validates :email, presence: {message: "Please enter an email address"},
                    uniqueness: {message: "This email address already exists"},
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Please enter a valid email address"}

  validates :first_name, presence: {message: "Please enter your first name"}
  validates :last_name, presence: {message: "Please enter your last name"}

  validates :password, presence: {message: "Please enter your password"},
                       confirmation: {message: "Please check and re-enter your password."},
                       length: {minimum: 4, too_short: "Password must be at least 4 characters."},
                       :if => :should_validate_password?

  has_many :user_devices
  accepts_nested_attributes_for :user_devices
  
  has_many :devices, :through => :user_devices
  has_many :event_isopts, :through => :user_devices

  validate :init_time_must_be_in_range  

  def current_user_device
    self.user_devices.first
  end

  def current_event_isopt
    if self.current_user_device.present?
      self.current_user_device.event_isopt
    else
      nil
    end
  end


  def conv_to_json
    {
      id: self.id,
      first_name: self.first_name,
      last_name: self.last_name
    }
  end

  def fullname
    "#{self.first_name} #{self.last_name}"
  end

  def pst_ratio
    if self.init_time.present?
      60000 / self.init_time
    else
      nil
    end
  end

  def personal_current_time
    self.personal_time
  end

  def personal_time
    if self.is_initialized?
      # get actual time difference between now and when the user started
      td = TimeDifference.between(self.init_at.to_time, Time.now)
      # calculate actual number of seconds the user has spent recording moments
      moment_time = 0
      
      self.moment_records.each do |m|
        moment_time += m.milliseconds / 1000.0
      end

      # convert to personal time according to user's minute.
      personal_time = self.init_at.to_time + ((moment_time.seconds + td.in_seconds) * 1000 / self.init_time).minutes
      
      personal_time
    else
      Time.now
    end
  end


  def should_validate_password?
    updating_password || new_record?
  end

  def init_time_must_be_in_range 
    if self.init_time.present?
      unless self.init_time >= 30000 and self.init_time <= 90000
        errors.add(:init_time, "must be ranged from 30000ms and 90000ms")
      end
    end
  end



end
