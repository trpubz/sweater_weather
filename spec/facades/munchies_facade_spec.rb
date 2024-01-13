require "rails_helper"

describe MunchiesFacade do
  describe "::get_business" do
    it "returns a business", :vcr do
      results = MunchiesFacade.get_business(cuisine: "mexican", location: "Del Norte, CO, USA")

      expect(results).to be_a(Hash)
      expect(results.keys).to include(:destination_city, :forecast, :restaurant)
    end

    it "raises an error if bad request", :vcr do
      allow(YelpApiService).to receive(:get_businesses).and_return(
        {
          status: 400,
          data: {
            error: {
              code: "VALIDATION_ERROR",
              field: "Authorization"
            }
          }
        }
      )

      expect { MunchiesFacade.get_business(cuisine: "mexican", location: "Del Norte, CO, USA") }
        .to raise_error(Faraday::BadRequestError)
    end
  end
end
