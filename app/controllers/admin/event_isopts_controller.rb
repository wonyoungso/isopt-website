class Admin::EventIsoptsController < Admin::AdminController
  def index
    @event_isopts = EventIsopt.order('held_at DESC')
  end
  
  def activate
    @event_isopt = EventIsopt.find params[:id]

    EventIsopt.all.each do |ev|
      ev.is_activated = @event_isopt.id.to_i == ev.id.to_i
      ev.save
    end

    redirect_to request.referer, :notice => 'Successfully Activated.'
  end

  def deactivate
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.is_activated = false
    if @event_isopt.save
      redirect_to request.referer, :notice => 'Successfully Deactivated.'
    else
      redirect_to request.referer, :alert => 'Error occured.'
    end
  end

  def new
    @event_isopt = EventIsopt.new
  end

  def create
    @event_isopt = EventIsopt.new(params.require(:event_isopt).permit(:held_at, :venue_name))

    if @event_isopt.save
      redirect_to edit_admin_event_isopt_path(@event_isopt), :notice => 'Successfully created Event.'
    else
      render :new
    end
  end

  def update
    @event_isopt = EventIsopt.find params[:id]

    if @event_isopt.update_attributes(params.require(:event_isopt).permit(:held_at, :venue_name))
      redirect_to edit_admin_event_isopt_path(@event_isopt), :notice => 'Successfully Updated Event.'
    else
      render :edit
    end
  end

  def edit
    @event_isopt = EventIsopt.find params[:id]
  end

  def destroy
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.destroy

    redirect_to admin_event_isopts_path, :notice => 'Successfully Destroyed Event.'
  end
end
