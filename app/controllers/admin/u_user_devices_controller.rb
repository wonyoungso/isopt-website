class Admin::UUserDevicesController < Admin::AdminController
  before_filter :find_user

  def index
    @user_device = @user.user_devices.first
    if @user_device.present?
      @title = "##{@user_device.id} Edit Allocation"
    else
      @title = "New Allocation"
      @user_device = UserDevice.new
    end

  end


  def edit
    @user_device = UserDevice.find params[:id]
  end
  
  def create
    @user_device = UserDevice.new(params.require(:user_device).permit(:device_id, :user_id, :event_isopt_id))
    @user_device.user = User.find(params[:user_id]) 
    

    respond_to do |format|
      if @user_device.save
        format.html { redirect_to request.referer, :notice => 'Successfully Allocated' }
        format.json { render json: {success: true }, status: 200 }
      else
        format.html { redirect_to request.referer, :alert => "Error Occured: #{@user_device.errors.full_messages.join(' ')}" } 
        format.json { render json: {success: false }, status: 500 }
      end
    end
  end

  def update
    @user_device = UserDevice.find params[:id]
    if params[:user_id] == nil
      @user_device.device = nil
      params[:user_device][:device_id] = nil
    end

    respond_to do |format|
      if @user_device.update_attributes(params.require(:user_device).permit(:device_id, :user_id, :event_isopt_id))
        format.html { redirect_to request.referer, :notice => 'Successfully Updated' } 
        format.json { render json: {success: true }, status: 200 }
      else
        format.html {  redirect_to request.referer, :alert => "Error Occured: #{@user_device.errors.full_messages.join(' ')}" }
        format.json { render json: {success: false }, status: 500 }
      end
    end
  end

  def destroy
  end

  private
  def find_user
    @user = User.find params[:user_id]
  end
end