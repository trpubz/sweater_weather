class MqFacade
  # @return Hash: {lat: Float, lng: Float}
  def self.get_lat_long(location)
    response = MqService.get_lat_lon(location)
    if response[:status] == 200
      response[:data][:results].first[:locations].first[:latLng]
      # else -- impossible to get bad request error from mapquest
      #   raise Faraday::BadRequestError, "Mapquest API error: #{response[:status]}"
    end
  end
end
