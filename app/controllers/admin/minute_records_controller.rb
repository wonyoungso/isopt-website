class Admin::MinuteRecordsController < Admin::AdminController
  before_filter :find_user

  def index
    @minute_records = @user.minute_records
  end

  def edit
    @minute_record = MinuteRecord.find params[:id]
  end

  def update
    @minute_record = MinuteRecord.find params[:id]
    if @minute_record.update_attributes(params.require(:minute_record).permit(:milliseconds))
      redirect_to request.referer, :notice => 'successfully updated minute record.'
    else
      redirect_to request.referer, :alert => "Error occured"
    end
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end
end