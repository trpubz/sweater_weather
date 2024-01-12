class Api::V0::ForecastController < ApplicationController
  def search
    application = "application/json"
    if params["Accept"] != application
      render json: {error: "I'm only returning json so Accept must be application/json"}, status: 406
    end

    MqFacade.get_lat_long(params[:location])
  end
end
