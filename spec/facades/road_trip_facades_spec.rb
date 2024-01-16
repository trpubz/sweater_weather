require "rails_helper"

RSpec.describe RoadTripFacade do
  describe "::validate_api_key" do
    it "validates the api key" do
      user = create :user
      expect(RoadTripFacade.validate_api_key(user.api_key)).to be_truthy
    end

    it "raises an error if the api key is invalid" do
      _ = create :user
      expect { RoadTripFacade.validate_api_key("invalid_api_key") }
        .to raise_error(Faraday::UnauthorizedError)
    end
  end
  describe "::create_road_trip" do
    it "creates a road trip" do

    end
  end
end
