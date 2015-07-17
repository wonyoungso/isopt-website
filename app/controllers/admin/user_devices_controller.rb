class Admin::UserDevicesController < Admin::AdminController


  def assign
    
    unless params[:user_id].present?
      @user_device = UserDevice.where(device_id: params[:device_id], event_isopt_id: params[:event_isopt_id]).first
      
      if @user_device.present?
        @user_device.device_id = nil 

         respond_to do |format|
          if @user_device.save
            format.html { redirect_to request.referer, :notice => 'Successfully Updated' } 
            format.json { render json: {success: true }, status: 200 }
          else
            format.html {  redirect_to request.referer, :alert => "Error Occured: #{@user_device.errors.full_messages.join(' ')}" }
            format.json { render json: {success: false }, status: 500 }
          end
        end
      end

      return 
    else
      @user_device = UserDevice.where(event_isopt_id: params[:event_isopt_id], user_id: params[:user_id]).first
      @user_device.device_id = params[:device_id]
      # byebug
       respond_to do |format|
        if @user_device.save
          format.html { redirect_to request.referer, :notice => 'Successfully Updated' } 
          format.json { render json: {success: true }, status: 200 }
        else
          format.html {  redirect_to request.referer, :alert => "Error Occured: #{@user_device.errors.full_messages.join(' ')}" }
          format.json { render json: {success: false }, status: 500 }
        end
      end

      return
    end
  end

end
