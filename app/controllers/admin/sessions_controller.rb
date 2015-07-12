class Admin::SessionsController < ApplicationController
  layout 'admin'
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user.present?
      if @user.try(:authenticate, params[:password])
        if @user.admin?
          session[:user_id] = @user.id

          redirect_to admin_root_path, :notice => '성공적으로 로그인 되었습니다.'
        else  
          @valid_data = {
            type: "pw_error",
            message: "Only authenticated admin can access this page."
          }

          render :template => '/admin/sessions/new', :handlers => [:erb]
        end
      else
        @valid_data = {
          type: "pw_error",
          message: "Wrong Password"
        }

        render :template => '/admin/sessions/new', :handlers => [:erb]
      end
    else
      @valid_data = {
        type: "login_error", 
        message: "Wrong Email"
      }

      render :template => '/admin/sessions/new', :handlers => [:erb]
    end

  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end
end