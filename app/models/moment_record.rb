class MomentRecord < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true

  def conv_to_json
    json = {
      submitted_at: self.submitted_at.strftime("%Y/%m/%d %H:%M:%S"),
      milliseconds: self.milliseconds,
      id: self.id
    }

    json[:start_time] =  self.submitted_at.strftime("%l:%M%P")
    json[:end_time] = (self.submitted_at + (self.milliseconds.to_f / 1000).second).strftime("%l:%M%P")

    json[:minute_idx] = TimeDifference.between(self.submitted_at, self.user.init_at).in_minutes if self.user.is_initialized?
    json
  end
end
