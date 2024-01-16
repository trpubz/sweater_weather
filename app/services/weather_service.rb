class WeatherService < TrdPartyServices
  def self.get_forecast(lat, lon, days)
    response = conn.get("forecast.json") do |req|
      req.params.merge!(
        {
          "q" => "#{lat},#{lon}",
          "days" => days
        }
      )
    end

    response_conversion(response)
  end

  def self.conn
    Faraday.new("http://api.weatherapi.com/v1/") do |conn|
      conn.params = {"key" => Rails.application.credentials.weather_key}
    end
  end
end
