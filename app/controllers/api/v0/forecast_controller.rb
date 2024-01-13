class Api::V0::ForecastController < ApplicationController
  def search
    application = "application/json"
    if params["Accept"] != application
      render json: {error: "I'm only returning json so Accept must be application/json"}, status: 406
    end

    lat_lon = MqFacade.get_lat_long(params[:location])
    # use lat_lon to get weather
    forecast = WeatherFacade.get_forecast(lat_lon)
  end
end
