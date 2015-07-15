class User < ActiveRecord::Base
  has_secure_password

  belongs_to :event_isopt
  has_many :minute_records
  attr_accessor :updating_password
  
  validates :email, presence: {message: "Please enter an email address"},
                    uniqueness: {message: "This email address already exists"},
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Please enter a valid email address"}

  validates :first_name, presence: {message: "Please enter your first name"}
  validates :last_name, presence: {message: "Please enter your last name"}

  validates :password, presence: {message: "Please enter your password"},
                       confirmation: {message: "Please check and re-enter your password."},
                       length: {minimum: 4, too_short: "Password must be at least 4 characters."},
                       :if => :should_validate_password?

  validates :device_id, presence: {message: 'Please enter a device id'},
                        uniqueness: {scope: [:event_isopt_id], message: 'This device id is already exists.' }

  validates :event_isopt_id, presence: {message: 'Please choose an event date.' }
  validate :init_time_must_be_in_range  

  def fullname
    "#{self.first_name} #{self.last_name}"
  end


  def should_validate_password?
    updating_password || new_record?
  end

  def init_time_must_be_in_range 
    if self.init_time.present?
      unless self.init_time > 30000 and self.init_time < 90000
        errors.add(:init_time, "must be ranged from 30000ms and 90000ms")
      end
    end
  end



end
