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
end
