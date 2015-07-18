class WelcomeController < ApplicationController
  def index
    @users = User.where(is_initialized: true)
    @event_isopts = EventIsopt.where(is_resettable: false, is_published: true)
  end
end
