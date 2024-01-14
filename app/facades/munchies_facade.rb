class MunchiesFacade
  def self.get_business(cuisine:, location:)
    lat_lng = MqFacade.get_lat_lng(location)  # {lat: Float, lng: Float}
    current_weather = WeatherFacade.get_weather(lat_lng[:lat], lat_lng[:lng])[:current_weather]
    results = YelpApiService.get_businesses(cuisine: cuisine, lat: lat_lng[:lat], lng: lat_lng[:lng])

    if results[:status] == 200 && !lat_lng.nil? && !current_weather.nil?
      best = results[:data][:businesses].first
      {
        destination_city: "#{best[:location][:city]}, #{best[:location][:state]}",
        forecast: {
          summary: current_weather[:condition],
          temperature: current_weather[:temperature]
        },
        restaurant: {
          name: best[:name],
          address: best[:location][:display_address],
          rating: best[:rating],
          reviews: best[:review_count]
        }
      }
    else
      raise Faraday::BadRequestError, "Yelp API error: #{results[:status]}, #{results[:data][:error][:code]}"
    end
  end
end
