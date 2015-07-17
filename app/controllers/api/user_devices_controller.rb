class Api::UserDevicesController < ApplicationController 
  def show
    @user_device = UserDevice.find params[:id]
    render json: {success: true, user_device: @user_device.conv_to_json}
  end 

  def status
    @sim_card_id = params[:sim_id]

    @device = Device.where(sim_card_id: @sim_card_id).first
    
    if @device.present?

      @user_device = @device.current_user_device
      if @user_device.present?
        @user_device.update_column(:updated_at, DateTime.now)
        UserDeviceLog.create(user_device_id: @user_device.id, description: "GET /api/box/#{params[:sim_id]}/status")
        render json: {
          success: true, 
          status: @user_device.state,
          sim_id: @user_device.device.sim_card_id,
          start_time: @user_device.user.init_at.to_time,
          minute_in_ms: @user_device.user.init_time,
          personal_time: @user_device.user.personal_time
        }
          # {"state" => @state, "sim_id" => @sim_id, "start_time" => @start_time, "minute_in_ms" => @minute_in_ms, "personal_time" => self.personal_time}.to_s
      else
        render json: {
          success: true, 
          status: :state_inactive,
          sim_id: @device.sim_card_id,
          start_time: nil,
          minute_in_ms: nil,
          personal_time: nil
        }       
      end

    else
      render json: {success: false, message: "No such box."}
    end
  end

  def minute_record
    @device = Device.where(sim_card_id: params[:sim_id]).first
    mms = params[:minute_in_ms].to_i
    
    if @device.present? 
      @user_device = @device.current_user_device

      if @user_device.present? 

        if mms >= 30000 and mms <= 90000
          if @user_device.set_minute(mms)

            @user_device.update_column(:updated_at, DateTime.now)
            UserDeviceLog.create(user_device_id: @user_device.id, description: "GET /api/box/#{params[:sim_id]}/minute_record/#{params[:minute_in_ms]}")
            render json: {success: true, message: "Minute record for box #{params[:sim_id]} set to #{mms}" }
          else
            render json: {success: false, message: "Box is not in :state_waiting_for_minute right now." }
          end
        else   
          render json: {success: false, message: "Error, minute record too short."}
        end


      else
        render json: {success: false, message: "Error, This box is in :state_inactive right now."}
      end


    else
      render json: {success: false, message: "No such box."}
    end 
  end


  def moment_record
    @device = Device.where(sim_card_id: params[:sim_id]).first
    mms = params[:minute_in_ms].to_i
    
    if @device.present?   
      @user_device = @device.current_user_device

      if @user_device.present? 

        if mms > 0
          if  @user_device.add_moment(mms)
            
            @user_device.update_column(:updated_at, DateTime.now)
            UserDeviceLog.create(user_device_id: @user_device.id, description: "GET /api/box/#{params[:sim_id]}/moment_record/#{params[:minute_in_ms]}")
            render json: {success: true, message: "Moment record for box #{params[:sim_id]} recorded at #{Time.now} for #{mms} milliseconds" }

          else
            render json: {success: false, message: "Box is not in :state_active right now."}
          end
        else
          render json: {success: false, message:  "Error, wrong request."}
        end

      else
        render json: {success: false, message: "Error, This box is in :state_inactive right now."}
      end

    else
      render json: {success: false, message: "No such box."}
    end 

  end
  
end