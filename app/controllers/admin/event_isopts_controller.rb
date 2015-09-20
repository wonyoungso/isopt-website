class Admin::EventIsoptsController < Admin::AdminController
  def index
    @event_isopts = EventIsopt.order('held_at DESC')
  end

  def publish
  
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.is_published = true
    @event_isopt.save

    redirect_to request.referer, :notice => 'Successfully Published'
  end

  def unpublish

    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.is_published = false
    @event_isopt.save

    redirect_to request.referer, :notice => 'Successfully Unpublished'
  end

  def set_to_test
  
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.is_resettable = true
    @event_isopt.save

    redirect_to request.referer, :notice => 'Successfully set to test mode'
  end

  def set_to_production
  
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.is_resettable = false
    @event_isopt.save

    redirect_to request.referer, :notice => 'Successfully set to production mode'
  end



  def reset
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.started_at = nil#DateTime.now
    @event_isopt.is_activated = false
    @event_isopt.is_ended = false
    @event_isopt.ended_at = nil
    @event_isopt.save

    redirect_to request.referer, :notice => 'Successfully Reset'

  end

  def show
    @event_isopt = EventIsopt.find params[:id]


    if  @event_isopt.is_ended? and @event_isopt.is_activated?
      offset = "_ended"
    elsif @event_isopt.is_activated?
      offset = "_active"
    else
      offset = "_inactive"
    end
    
    render template: "admin/event_isopts/show#{offset}"
  end

  def devices_table
    @event_isopt = EventIsopt.find params[:id]
    render :layout => false, :template => '/admin/event_isopts/_devices_table'
  end
  
  def activate
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.started_at = DateTime.now
    @event_isopt.is_activated = true 
    @event_isopt.save 

    @event_isopt.reset_all_records!

    redirect_to request.referer, :notice => 'Successfully Started.'
  end

  def ended
    @event_isopt = EventIsopt.find params[:id]
    @event_isopt.is_ended = true
    @event_isopt.ended_at = DateTime.now
    @event_isopt.save 
    

    redirect_to request.referer, :notice => 'Successfully Ended.'

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
    @event_isopt = EventIsopt.new(params.require(:event_isopt).permit(:consensus_time_code, :title, :held_at, :venue_name, :tz_offset))

    if @event_isopt.save
      redirect_to edit_admin_event_isopt_path(@event_isopt), :notice => 'Successfully created Event.'
    else
      render :new
    end
  end

  def update
    @event_isopt = EventIsopt.find params[:id]

    if @event_isopt.update_attributes(params.require(:event_isopt).permit(:consensus_time_code, :title, :held_at, :venue_name, :tz_offset))
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
