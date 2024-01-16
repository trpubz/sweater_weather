require "rails_helper"

RSpec.describe MqFacade do
  describe "::get_lat_lon" do
    it "returns a hash of the lat lon data", vcr: {record: :new_episodes} do
      lat_lng = MqFacade.get_lat_lng("Del Norte, CO, USA")
      expect(lat_lng).to be_a(Hash)
      expect(lat_lng.keys).to include(:lat, :lng)
      expect(lat_lng.values.first).to be_a(Float)
    end
  end

  describe "::get_directions" do
    it "returns a hash of the directions data", vcr: {record: :new_episodes} do
      directions = MqFacade.get_directions("Del Norte, CO, USA", "Monte Vista, CO, USA")

      expect(directions).to be_a(Hash)
      expect(directions.keys).to include(:travel_time, :start_city, :end_city)
      expect(directions[:start_city]).to eq "Del Norte, CO"
    end

    it "raises an error if the route is inaccessible", vcr: {record: :new_episodes} do
      expect { MqFacade.get_directions("Del Norte, CO, USA", "Tromso, Norway") }
        .to raise_error(Faraday::BadRequestError)
        .with_message("Mapquest API error: 402, [\"We are unable to route with the given locations.\"]")
    end
  end
end
