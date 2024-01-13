require "rails_helper"

RSpec.describe "Api::V0::Forecasts", type: :request do
  describe "GET /forecast", vcr: {record: :new_episodes} do
    it "returns http success" do
      get api_v0_forecast_path,
        headers: {"Accept" => "application/json"},
        params: {location: "Del Norte, CO"}

      expect(response).to have_http_status(:success)
    end
  end
end
