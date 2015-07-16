class Api::UserDevicesController < ApplicationController 
  def show
    @user_device = UserDevice.find params[:id]
    render json: {success: true, user_device: @user_device.conv_to_json}
  end 

  # Initialization
  # parameters:
  ############# id = user_device_id
  ############# milliseconds
  def create_init_time
    #
    # if @user_device.event_isopt.is_activated?
    #   @user_device.user.init_time = params[:milliseconds]
    # end
  end


  # Create Minute Record.
  # parameters:
  ############# id = user_device_id
  ############# milliseconds
  def create_minute_record
    #
    # if @user_device.event_isopt.is_activated?
    #   THEN CREATE
    # end
  end


  # Feel Free to add method!
end