require "rails_helper"

RSpec.describe MqFacade do
  describe "::get_lat_lon" do
    it "returns a hash of the lat lon data", :vcr do
      lat_lon = MqFacade.get_lat_long("Del Norte, CO")
      expect(lat_lon).to be_a(Hash)
      expect(lat_lon.keys).to include(:lat, :lng)
      expect(lat_lon.values.first).to be_a(Float)
    end
  end
end
