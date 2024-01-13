class YelpApiService < TrdPartyServices
  def self.get_businesses(cuisine:, lat:, lng:)
    response = conn.get("businesses/search") do |req|
      req.params["latitude"] = lat.to_s
      req.params["longitude"] = lng.to_s
      req.params["term"] = "food"
      req.params["categories"] = cuisine.to_s
      req.params["sort_by"] = "best_match"
    end

    response_conversion(response)
  end

  def self.conn
    Faraday.new("https://api.yelp.com/v3/") do |conn|
      conn.headers["Authorization"] = "Bearer #{Rails.application.credentials.yelp_api_key}"
      conn.headers["Accept"] = "application/json"
    end
  end
end
