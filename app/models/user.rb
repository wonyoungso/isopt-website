class User < ActiveRecord::Base
  has_secure_password

  belongs_to :event_isopt
  has_many :minute_records
  
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
  validates :init_time_must_be_in_range  

  def fullname
    "#{self.first_name} #{self.last_name}"
  end

  def init_time_must_be_in_range 
    unless init_time > 30000 and init_time < 90000
      errors.add(:init_time, "must be ranged from 30000ms and 90000ms")
    end
  end



end
