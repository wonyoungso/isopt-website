#encoding utf-8
class UsersController < ApplicationController
  before_filter :owner_required, :only => [:edit, :update, :password_update]
  def new
    @user = User.new
    @user_device = @user.user_devices.build
    render layout: 'application'
  end

  def show
    @user = User.find params[:id]


    if @user.is_initialized? and @user.current_event_isopt.present?
      @minutes = TimeDifference.between(@user.init_at, Time.now).in_minutes

      render :template => '/users/show'
    else
      render :template => '/users/not_ready'
    end

  end

  def edit
    @user = User.find params[:id]
  end

  def password_update
    @user = User.find params[:id]
    @user.updating_password = true

    unless @user.try(:authenticate, params[:old_password])
      @password_alert = 'Current Password Incorrect'
      render "edit"
      return
    end

    if @user.update_attributes(params.require(:user).permit(:password, :password_confirmation))
      flash[:notice] = 'Successfully updated password.'
      redirect_to edit_user_path(@user)
      return
    else
      render 'edit'  
      return
    end
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :first_name, :last_name, :username, :password, :password_confirmation, user_devices_attributes: [:event_isopt_id, :user_id]))

    if @user.save
      session[:user_id] = @user.id
    else  
      render :new
    end
  end

  def owner_required

    @user = User.find params[:id]
    unless @user == current_user 
      redirect_to root_path
    end
  end
end
