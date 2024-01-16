require "rails_helper"

describe WeatherFacade do
  describe "#get_weather" do
    it "returns a weather object matching requirements", :vcr do
      results = WeatherFacade.get_weather(37.67537, -106.35347, 5)

      expect(results).to be_a(Hash)
      expect(results).to have_key(:current_weather)
      expect(results).to have_key(:daily_weather)
      expect(results).to have_key(:hourly_weather)
      expect(results[:current_weather]).to be_a(Hash)
      expect(results[:daily_weather]).to be_a(Array)
      expect(results[:hourly_weather]).to be_a(Array)
      expect(results[:current_weather]).to have_key(:last_updated)
      expect(results[:current_weather]).to have_key(:temperature)
      expect(results[:current_weather]).to have_key(:feels_like)
      expect(results[:daily_weather].count).to eq(5)
      expect(results[:hourly_weather].count).to eq(120)
      expect(results[:daily_weather].first).to be_a(Hash)
      expect(results[:daily_weather].first).to have_key(:date)
      expect(results[:daily_weather].first).to have_key(:sunrise)
      expect(results[:daily_weather].first).to have_key(:sunset)
      expect(results[:daily_weather].first).to have_key(:max_temp)
      expect(results[:daily_weather].first).to have_key(:min_temp)
      expect(results[:hourly_weather].first).to be_a(Hash)
      expect(results[:hourly_weather].first).to have_key(:time)
      expect(results[:hourly_weather].first).to have_key(:temperature)
      expect(results[:hourly_weather].first).to have_key(:condition)

      expect(results[:current_weather]).to_not have_key(:temp_c)
      expect(results[:current_weather]).to_not have_key(:cloud)
      expect(results[:current_weather]).to_not have_key(:wind_mph)
    end

    it "raises an error if the status is bad", :vcr do
      allow(WeatherService).to receive(:get_forecast).and_return(
        {
          status: 403,
          data: {
            error: {
              code: 2008,
              message: "API key is missing or invalid."
            }
          }
        }
      )

      expect { WeatherFacade.get_weather(37.67537, -106.35347, 5) }.to raise_error(Faraday::BadRequestError)
    end
  end
end
