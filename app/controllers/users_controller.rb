#encoding utf-8
class UsersController < ApplicationController
  before_filter :owner_required, :only => [:edit, :update, :password_update]
  def new
    @user = User.new
    @user_device = @user.user_devices.build
    render layout: 'application'
  end

  def show
    @user = User.where(username: params[:username]).first

    if @user.present?
      if @user.is_initialized? and @user.current_event_isopt.present?
        # @end_time = @user.current_event_isopt.is_ended? ? @user.current_event_isopt.ended_at
        @minutes = TimeDifference.between(@user.init_at, @user.current_event_isopt.ended_at).in_minutes

        render :template => '/users/show'
      else
        render :template => '/users/not_ready'
      end
    else
      render text: 'No such user.'
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
      redirect_to user_path(@user.username)
      return
    else
      render 'edit'  
      return
    end
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :first_name, :last_name, :username, :password, :password_confirmation, user_devices_attributes: [:event_isopt_id, :user_id]))

    unless @user.save
    # else  
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
