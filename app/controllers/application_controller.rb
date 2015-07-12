class ApplicationController < ActionController::Base
  # include Mobu::DetectMobile
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :logged_in?, :current_user


  def login_required
    if !logged_in?
      respond_to do |format|
        format.html { redirect_to admin_login_path, :alert => "You must authenticate." }
        format.json { { success: false, message: 'You must authenticate.'} }
      end
    end
  end

  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end 

  def current_user= user
    session[:user_id] = user.is_a?(User) ? user.id : nil
    @current_user = user
  end


  def logged_in?
    current_user.present? and current_user.is_a?(User)
  end


end
