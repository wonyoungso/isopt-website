require 'sinatra'
require 'data_mapper'
require 'time_difference'
require 'slim'



# I am combining User class and Box class in this example.
# for the real thing, minute_record, and moment_records
# should be associated with User class, which is accessed through Box.

class Box
  
  @@STATES = [:state_inactive, :state_waiting_for_minute, :state_active]
  
  attr_accessor :state, :sim_id, :minute_in_ms, :start_time, :moments
  
  def initialize(sim_id)
    @state = :state_inactive
    @sim_id = sim_id
    @start_time = Time.now
    @minute_in_ms = 0
    @moments = []
  end
  
  def session_start()
    @state = :state_waiting_for_minute
    @start_time = Time.now
    @minute_in_ms = 0
    @moments = []
  end
  
  def session_end()
    @state = :state_inactive
  end
  
  ## returns false if we're not allowed to set a minute record right now.
  ## changes state to ACTIVE if successful.
  def set_minute(minute_in_milliseconds)
    if @state != :state_waiting_for_minute
      return false
    end
    @start_time = Time.now
    @minute_in_ms = minute_in_milliseconds
    @state = :state_active
    return true
  end
  
  def add_moment(moment_in_milliseconds)
    if @state != :state_active
      return false
    end
    @moments << {:time => Time.now, :milliseconds => moment_in_milliseconds}
    return true
  end
  
  def personal_time()
    if @state == :state_active
      # get actual time difference between now and when the user started
      td = TimeDifference.between(@start_time, Time.now)
      # calculate actual number of seconds the user has spent recording moments
      moment_time = 0
      for m in @moments do
        moment_time += m[:milliseconds]/1000.0
      end
      # convert to personal time according to user's minute.
      personal_time = @start_time + ((moment_time.seconds + td.in_seconds) * 1000 / @minute_in_ms).minutes
      return personal_time
    else
      return Time.now
    end
  end
  
  def to_s()
    return {"state" => @state, "sim_id" => @sim_id, "start_time" => @start_time, "minute_in_ms" => @minute_in_ms, "personal_time" => self.personal_time}.to_s
  end
end


class Boxes
  @@boxes = []
  def self.init()
    @@boxes << Box.new("ABCD")
  end
  def self.get_box(sim_id)
    for box in @@boxes do
      if box.sim_id == sim_id
        return box
      end
    end
    return nil
  end
  def self.session_start()
    for box in @@boxes do
      box.session_start()
    end
  end
  def self.session_end()
    for box in @@boxes do
      box.session_end()
    end
  end
  
end

class Session
  @@start_time = Time.now
  @@session_id = 0
  @@active = false
  def self.start()
    @@start_time = Time.now
    @@session_id = @@start_time.to_i
    @@active = true
    # Activate all boxes
    Boxes::session_start()
  end
  def self.stop()
    @@active = false
    Boxes::session_end()
  end
  def self.active?()
    return @@active
  end
  def self.start_time()
    return @@start_time
  end
  def self.session_id()
    return @@session_id
  end
  def self.status()
    return { "start time" => @@start_time, "session id" => @@session_id, "active?" => @@active }
  end
end

configure do
  Boxes::init()
end

get '/' do
  Session::status().to_s
end

get '/start_event' do
  Session::start()
  "Session started: " + Session::status().to_s
end

get '/stop_event' do
  Session::stop()
  "Session stopped: " + Session::status().to_s
end

get '/box/:sim_id/status' do
  box = Boxes::get_box(params[:sim_id])
  if (box != nil)
    resp = box.to_s
  else
    resp = "No such box."     
  end
end

get '/box/:sim_id/minuterecord/:minute_in_ms' do
  box = Boxes::get_box(params[:sim_id])
  mms = params[:minute_in_ms].to_i
  
  if (box != nil)  
    if (mms >= 30000 and mms <= 90000)
      if (box.set_minute(mms))
        resp = "Minute record for box #{params[:sim_id]} set to #{mms}"
      else
        resp = "Box is not in :state_waiting_for_minute right now."
      end
    else
      resp = "Error, minute record too short."
    end
  else
    resp = "no such box"
  end 
  resp
end

get '/box/:sim_id/momentrecord/:moment_in_ms' do
  box = Boxes::get_box(params[:sim_id])
  mms = params[:moment_in_ms].to_i
  
  if (box != nil)  
    if (mms > 0)
      if (box.add_moment(mms))
        resp = "Moment record for box #{params[:sim_id]} recorded at #{Time.now} for #{mms} milliseconds"
      else
        resp = "Box is not in :state_active right now."
      end
    else
      resp = "Error, wrong request."
    end
  else
    resp = "no such box"
  end 
  resp
end



post '/new' do
  
  ms = params['new_time'][:milliseconds]
  user_id = params['new_time'][:user_id]
  password = params['new_time'][:password]
  
  # make sure password matches.
  if SecretPassword.last.password != password
    redirect to('/')
    return
  end
  
  # make sure our milliseconds are in a reasonable range, 30-90 seconds.
  if (ms.to_i > 30000 and ms.to_i < 90000) then
    # delete all other records from this user
    MinuteRecord.all(:user_id => user_id).destroy
    # create a new record for this user
    MinuteRecord.create(:milliseconds => ms.to_i, :submitted_at => Time.now, :user_id => user_id)
    total_milliseconds = 0
    # take an average of all time records
    for r in MinuteRecord.all do
      total_milliseconds += r.milliseconds 
    end
    seconds_in_a_minute = total_milliseconds / 1000.0 / MinuteRecord.all.count
    
    # get current timecode
    current_timecode = get_current_timecode()
    
    # create a new timeshift, starting at the current timecode, with the new negotiated time
    TimeShift.create(:actual_time => Time.now, :timecode_start => current_timecode, :minute_in_seconds => seconds_in_a_minute)
    
  end
  redirect to('/')
end