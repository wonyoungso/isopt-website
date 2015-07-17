class Api::MomentRecordsController < ApplicationController
  before_filter :find_user
  
  def create
    @moment_record = MomentRecord.new
    @moment_record.user = @user
    @moment_record.submitted_at = DateTime.now
    @moment_record.milliseconds = params[:milliseconds]

    if @moment_record.save
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