class MqService < TrdPartyServices
  def self.get_lat_lng(location)
    response = conn.get("geocoding/v1/address?") do |req|
      req.params.merge!(
        {
          "location" => location,
          "thumbMaps" => false,
          "outFormat" => "json"
        }
      )
    end

    response_conversion(response)
  end

  def self.get_directions(from, to)
    response = conn.get("/directions/v2/route?") do |req|
      req.params.merge!(
        {
          "from" => from,
          "to" => to,
          "routeType" => "fastest",
          "outFormat" => "json"
        }
      )
    end

    data = JSON.parse(response.body, symbolize_names: true)
    if data.has_key?(:info) && data[:info].has_key?(:statuscode)
      # see codes here: https://developer.mapquest.com/documentation/directions-api/status-codes/
      if data[:info][:statuscode] != 0  # anything other than 0 is an error
        status = data[:info][:statuscode]
        data = data[:info][:messages]
        return {status: status, data: {messages: data}}
      end
    end

    response_conversion(response)
  end

  def self.conn
    Faraday.new("https://www.mapquestapi.com/") do |conn|
      conn.request :url_encoded
      conn.params = {"key" => Rails.application.credentials.mapquest_key}
    end
  end
end
