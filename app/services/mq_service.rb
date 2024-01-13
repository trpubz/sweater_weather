class MqService < TrdPartyServices
  def self.get_lat_lon(location)
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

  def self.conn
    Faraday.new("https://www.mapquestapi.com/") do |conn|
      conn.request :url_encoded
      conn.params = {"key" => Rails.application.credentials.mapquest_key}
    end
  end
end
