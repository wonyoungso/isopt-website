class Admin::DevicesController < Admin::AdminController
  def index
    @devices = Device.all
  end

  def show
    @device = Device.find params[:id]
  end


  def new
    @device = Device.new
  end

  def create
    @device = Device.new(params.require(:device).permit(:human_id, :sim_card_id))

    if @device.save
      redirect_to edit_admin_device_path(@device), :notice => 'Successfully created Event.'
    else
      render :new
    end
  end

  def update
    @device = Device.find params[:id]

    if @device.update_attributes(params.require(:device).permit(:human_id, :sim_card_id))
      redirect_to edit_admin_device_path(@device), :notice => 'Successfully Updated Event.'
    else
      render :edit
    end
  end

  def edit
    @device = Device.find params[:id]
  end

  def destroy
    @device = Device.find params[:id]
    @device.destroy

    redirect_to admin_devices_path, :notice => 'Successfully Destroyed Event.'
  end
end
