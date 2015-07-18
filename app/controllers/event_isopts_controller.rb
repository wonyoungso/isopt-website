class EventIsoptsController < ApplicationController
  def show
    @event_isopt = EventIsopt.find params[:id]

    unless @event_isopt.is_published? 
      unless logged_in? and current_user.admin?
        render :text => 'Not yet published'
        return
      end    
    end

    



  end
end