class Admin::UsersController < Admin::AdminController
  def search
    @title = "Search Results of #{params[:query]}"
    @page = params[:page] || 1
    @users = User.where("username LIKE ? OR email LIKE ? OR fullname LIKE ? OR device_id LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
    render template: '/admin/users/index'
  end

  def password_reset 
    @user = User.find params[:id]

    @user_token = UserToken.new
    @user_token.user = @user
    if @user_token.save 

      UserSendPasswordResetMailWorker.perform_async(@user.id)

      redirect_to request.referer, :notice => 'Successfully sent reset email.'
    else
      redirect_to request.referer, :alert => "#{@user_token.errors.full_messages.join(' ')}"
    end
  end


  def index
    @title = "All Users"
    @users = User.order("created_at DESC")
  end

  def event_isopt
    @ev = EventIsopt.find params[:event_isopt_id]
    @title = "Users of #{@ev.held_at.strftime("%Y/%m/%d")}"
    @users = @ev.users

    render template: '/admin/users/index'
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    
    
    if @user.update_attributes(params.require(:user).permit(:email, :username, :first_name, :last_name))
      # @user.update_column(:subscribed_at, DateTime.now)

      flash[:notice] = 'Successfully updated.'
      render :edit
    else
      flash[:alert] = "#{@user.errors.full_messages.join(' ')}"
      redirect_to request.referer
    end

  end

  def update_init_time
    @user = User.find params[:id]
    
    @user.init_time = params[:user][:init_time]
    @user.is_initialized = true
    @user.init_at = DateTime.now


    if @user.save
      flash[:notice] = 'Successfully updated init_time.'
      render :edit
    else
      flash[:alert] = "#{@user.errors.full_messages.join(' ')}"
      redirect_to request.referer
    end

  end


  def destroy
    @user= User.find params[:id]
    @user.destroy
    redirect_to admin_users_path, :notice => 'Successfully destroyed'
  end

end
