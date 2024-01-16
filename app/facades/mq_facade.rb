class MqFacade
  # @return Hash: {lat: Float, lng: Float}
  def self.get_lat_lng(location)
    response = MqService.get_lat_lng(location)
    if response[:status] == 200
      response[:data][:results].first[:locations].first[:latLng]
      # else -- impossible to get bad request error from mapquest
      #   raise Faraday::BadRequestError, "Mapquest API error: #{response[:status]}"
    end
  end

  def self.get_directions(from, to)
    response = MqService.get_directions(from, to)
    if response[:status] == 200
      route = response[:data][:route]

      {
        travel_time: route[:formattedTime],  # "HH:MM:SS"
        start_city: "#{route[:locations].first[:adminArea5]}, #{route[:locations].first[:adminArea3]}",
        end_city: "#{route[:locations].last[:adminArea5]}, #{route[:locations].last[:adminArea3]}"
      }
    else
      raise Faraday::BadRequestError,
        "Mapquest API error: #{response[:status]}, #{response[:data][:messages]}"
    end
  end
end
