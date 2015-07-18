class Api::EventIsoptsController < ApplicationController
  def show
    @event_isopt = EventIsopt.find params[:id]

    render json: {success: true, event_isopt: @event_isopt.conv_to_json }

  end
end
