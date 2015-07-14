class Api::UsersController < ApplicationController
  def init_device
    @user = User.find params[:id]
    @user.init_time = params[:milleseconds].to_i
    @user.is_initialized = true
    @user.init_at = DateTime.now

    if @user.save
      render json: {success: true, message: "Successfully initialized device of #{@user.fullname}" }, status: 200
    else
      render json: {success: false, message: "Error occured", errors: @user.errors.messages }, status: 500
    end
  end
end
