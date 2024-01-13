require "rails_helper"

RSpec.describe "Api::V0::Forecasts", type: :request do
  describe "GET /forecast", vcr: {record: :new_episodes} do
    it "returns http success" do
      get api_v0_forecast_path,
        headers: {"Accept" => "application/json"},
        params: {location: "Del Norte, CO"}

      expect(response).to have_http_status(:success)
    end

    it "renders an error if the header is not set" do
      get api_v0_forecast_path,
        params: {location: "Del Norte, CO"},
        headers: {"Accept" => "application/xml"}

      expect(response).to have_http_status(:not_acceptable)
    end

    it "renders an error if there is a weather api error" do
      allow(WeatherService).to receive(:get_forecast).and_return(
        {
          status: 403,
          data: {
            error: {
              code: 2008,
              message: "API key has been disabled."
            }
          }
        }
      )

      get api_v0_forecast_path,
        headers: {"Accept" => "application/json"},
        params: {location: "Del Norte, CO"}

      # stub in bad api key error

      expect(response).to have_http_status(:bad_request)
    end
  end
end
