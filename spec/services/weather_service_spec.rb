require "rails_helper"

RSpec.describe WeatherService do
  # 37.67537, -106.35347
  describe "::get_forecast" do
    it "gets forecast for a given lat/long", :vcr do
      forecast = WeatherService.get_forecast(37.67537, -106.35347, 5)

      expect(forecast).to have_key(:status)
      expect(forecast).to have_key(:data)
      expect(forecast[:status]).to eq 200
      expect(forecast[:data]).to have_key(:current)
      expect(forecast[:data]).to have_key(:forecast)
    end
  end
end
