class RoadTripFacade
  def self.validate_api_key(key)
    User.find_by!(api_key: key)
  rescue Mongoid::Errors::DocumentNotFound => e
    raise Faraday::UnauthorizedError, "Invalid API key: #{e.message}"
  end

  def self.create_road_trip(from, to)
    # get directions with raise an error if there are no directions
    travel_time = begin
      MqFacade.get_directions(from, to)[:travel_time]
    rescue   # provide default value
      "impossible"
    end

    dest_weather = {}  # default to empty

    unless travel_time == "impossible"
      travel_hours = travel_time.split(":").first.to_i.hours
      travel_minutes = travel_time.split(":")[1].to_i.minutes
      eta = DateTime.now + travel_hours + travel_minutes
      lat_lng = MqFacade.get_lat_lng(to)  # destination lat/lng
      forecast = WeatherFacade.get_weather(lat_lng[:lat], lat_lng[:lng], travel_hours / 24 + 1)
      # forecast has an array of hourly forecasts, take the index that corresponds to the hour-out
      # drop the first numbers of indicies that correspond to the current time
      hourly_weathers = forecast[:hourly_weather]
      start_hour = DateTime.now.hour
      eta_hour_offset = start_hour + travel_hours / 60 / 60
      # no need for index offset since the 0th index is the 0th hour
      eta_weather = hourly_weathers[eta_hour_offset]

      dest_weather = {
        datetime: eta,
        temperature: eta_weather[:temperature],
        condition: eta_weather[:condition]
      }
    end

    {
      start_city: from,
      end_city: to,
      travel_time: travel_time,
      weather_at_eta: dest_weather
    }
  end
end
