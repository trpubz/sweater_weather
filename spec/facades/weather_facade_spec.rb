require "rails_helper"

describe WeatherFacade do
  describe "#get_weather" do
    it "returns a weather object matching requirements", :vcr do
      # a data attribute, under which all other attributes are present:
      # id, always set to null
      # type, always set to “forecast”
      # attributes, an object containing weather information:
      # current_weather, holds current weather data:
      # last_updated, in a human-readable format such as “2023-04-07 16:30”
      # temperature, floating point number indicating the current temperature in Fahrenheit
      # feels_like, floating point number indicating a temperature in Fahrenheit
      # humidity, numeric (int or float)
      # uvi, numeric (int or float)
      # visibility, numeric (int or float)
      # condition, the text description for the current weather condition
      # icon, png string for current weather condition
      # daily_weather, array of the next 5 days of daily weather data:
      # date, in a human-readable format such as “2023-04-07”
      # sunrise, in a human-readable format such as “07:13 AM”
      # sunset, in a human-readable format such as “08:07 PM”
      # max_temp, floating point number indicating the maximum expected temperature in Fahrenheit
      # min_temp, floating point number indicating the minimum expected temperature in Fahrenheit
      # condition, the text description for the weather condition
      # icon, png string for weather condition
      # hourly_weather, array of all 24 hour’s hour data for the current day:
      # time, in a human-readable format such as “22:00”
      # temperature, floating point number indicating the temperature in Fahrenheit for that hour
      # conditions, the text description for the weather condition at that hour
      # icon, string, png string for weather condition at that hour
      results = WeatherFacade.get_weather(37.67537, -106.35347)

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
      expect(results[:hourly_weather].count).to eq(24)
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

      expect { WeatherFacade.get_weather(37.67537, -106.35347) }.to raise_error(Faraday::BadRequestError)
    end
  end
end
