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
  end

end
