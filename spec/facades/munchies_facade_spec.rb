require "rails_helper"

describe MunchiesFacade do
  describe "::get_business" do
    it "returns a business", :vcr do
      results = MunchiesFacade.get_business(cuisine: "mexican", location: "Del Norte, CO, USA")

      expect(results).to be_a(Hash)
      expect(results.keys).to include(:destination_city, :forecast, :restaurant)
    end
  end
end
