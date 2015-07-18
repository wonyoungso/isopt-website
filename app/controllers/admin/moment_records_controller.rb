class Admin::MomentRecordsController < Admin::AdminController
  before_filter :find_user

  def index
    @moment_records = @user.moment_records
  end

  def edit
    @moment_record = MomentRecord.find params[:id]
  end

  def update
    @moment_record = MomentRecord.find params[:id]
    if @moment_record.update_attributes(params.require(:moment_record).permit(:milliseconds))
      redirect_to request.referer, :notice => 'successfully updated minute record.'
    else
      redirect_to request.referer, :alert => "Error occured"
    end
  end

  def destroy
    @moment_record = MomentRecord.find params[:id]
    
    @moment_record.destroy

    redirect_to referer, :notice => 'successfully destroyed.'
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end
end