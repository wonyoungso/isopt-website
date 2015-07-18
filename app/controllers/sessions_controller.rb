class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.where(email: params[:email]).first
    if @user.present?
      if @user.try(:authenticate, params[:password])
        session[:user_id] = @user.id

        if params[:redirection].present?
          redirect_to params[:redirection], :notice => 'login successful'
        else 
          redirect_to user_path(@user), :notice => 'login successful'
        end
      else
        @valid_data = {
          type: "Password",
          message: "This password does not match the email entered. Please check and re-enter your password."
        }
        @users = User.where(is_initialized: true)
        @event_isopts = EventIsopt.where(is_resettable: false, is_published: true)
        render :template => 'welcome/index', :handlers => [:erb]
      end
    else
      @valid_data = {
        type: "Email", 
        message: "This email does not exist. Please check the email you have entered."
      }
      @users = User.where(is_initialized: true)
      @event_isopts = EventIsopt.where(is_resettable: false, is_published: true)
      render :template => 'welcome/index', :handlers => [:erb]
    end

  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end
end