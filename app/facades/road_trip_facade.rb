class RoadTripFacade
  def self.validate_api_key(key)
    User.find_by!(api_key: key)
  rescue Mongoid::Errors::DocumentNotFound => e
    raise Faraday::UnauthorizedError, "Invalid API key: #{e.message}"
  end

  def self.create_road_trip(from, to)
    directions = MqFacade.get_directions(from, to)
    lat_lng = MqFacade.get_lat_lng(to)
    forecast = WeatherFacade.get_weather(lat_lng[:lat], lat_lng[:lng])
  end
end
