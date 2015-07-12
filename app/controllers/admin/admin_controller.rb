#encoding:utf-8
class Admin::AdminController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :authenticated_admin

  def authenticated_admin
    unless self.current_user.present? and self.current_user.admin
      redirect_to login_path, :alert => "you don't have permissions to access this page."
    end
  end
  
end
