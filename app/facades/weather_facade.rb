class WeatherFacade
  def self.get_weather(lat, lon, days)
    response = WeatherService.get_forecast(lat, lon, days)

    if response[:status] == 200
      data = response[:data]
      current_weather = data[:current]
      forecast = data[:forecast]

      {
        current_weather: {
          last_updated: current_weather[:last_updated],
          temperature: current_weather[:temp_f],
          feels_like: current_weather[:feelslike_f],
          humidity: current_weather[:humidity],
          uvi: current_weather[:uv],
          visibility: current_weather[:vis_miles],
          condition: current_weather[:condition][:text],
          icon: current_weather[:condition][:icon]
        },
        daily_weather: forecast[:forecastday].map do |day|
          {
            date: day[:date],
            sunrise: day[:astro][:sunrise],
            sunset: day[:astro][:sunset],
            max_temp: day[:day][:maxtemp_f],
            min_temp: day[:day][:mintemp_f],
            condition: day[:day][:condition][:text],
            icon: day[:day][:condition][:icon]
          }
        end,
        hourly_weather: forecast[:forecastday].map do |day|
          day[:hour].map do |hour|
            {
              time: hour[:time].split(" ")[1],  # remove date part @index 0
              temperature: hour[:temp_f],
              condition: hour[:condition][:text],
              icon: hour[:condition][:icon]
            }
          end
        end.flatten
      }
    else
      raise Faraday::BadRequestError, "Weather API error: #{response[:status]}, #{response[:data][:error][:message]}"
    end
  end
end
