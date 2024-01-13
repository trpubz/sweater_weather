class Api::V0::ForecastController < ApplicationController
  def search
    application = "application/json"
    if request.headers["Accept"] != application
      return render json: {error: "I'm only returning json so Accept must be application/json"}, status: 406
    end

    lat_lon = MqFacade.get_lat_lng(params[:location])
    # use lat_lon to get weather
    forecast = WeatherFacade.get_weather(lat_lon[:lat], lat_lon[:lng])

    render json:
       {
         data: {
           id: nil,
           type: "forecast",
           attributes: forecast
         }
       }.to_json
  end
end
