class MinuteRecord < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true

  def personal_current_time
    Time.zone.at(self.user.init_at.to_i + ((DateTime.now.to_i - self.init_at.to_i) * self.pst_ratio)).to_datetime
  end

end
