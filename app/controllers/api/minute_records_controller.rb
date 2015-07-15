class Api::MinuteRecordsController < ApplicationController
  before_filter :find_user
  
  def create
    @minute_record = MinuteRecord.new
    @minute_record.user = @user
    @minute_record.submitted_at = DateTime.now
    @minute_record.milliseconds = params[:milliseconds]

    if @minute_record.save
      render json: {success: true, message: "Successfully created minute record." }, status: 200
    else
      render json: {success: false, message: "Error occured.", errors: @user.errors.messages }, status: 500
    end
  end

  private
  def find_user
    @user = User.find params[:user_id]
  end
end
