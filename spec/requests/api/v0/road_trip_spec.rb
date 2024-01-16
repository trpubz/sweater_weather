require "rails_helper"

RSpec.describe "Api::V0::RoadTrip", type: :request do
  let(:valid_headers) {
    {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  }

  describe "POST #create" do
    context "with valid parameters" do
      before :each do
        DatabaseCleaner.clean

        @user = create :user
        @body = {
          origin: "Cincinnati,OH",
          destination: "Chicago,IL",
          api_key: @user.api_key
        }
      end

      it "renders a JSON response with the road trip details", :vcr do
        post api_v0_road_trip_path,
          headers: valid_headers, params: @body, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data).to have_key(:id)
        expect(data).to have_key(:type)
        expect(data[:attributes]).to have_key(:start_city)
        expect(data[:attributes]).to have_key(:end_city)
        expect(data[:attributes]).to have_key(:travel_time)
        expect(data[:attributes]).to have_key(:weather_at_eta)
        expect(data[:attributes][:weather_at_eta]).to have_key(:datetime)
        expect(data[:attributes][:weather_at_eta]).to have_key(:temperature)
        expect(data[:attributes][:weather_at_eta]).to have_key(:condition)
      end

      it "creates a road trip from NY to LA", :vcr do
        body = {
          origin: "New York City,NY",
          destination: "Los Angeles,CA",
          api_key: @user.api_key
        }
        post api_v0_road_trip_path,
          headers: valid_headers, params: body, as: :json

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      before :each do
        DatabaseCleaner.clean

        user = create :user
        @body = {
          origin: "New York,NY",
          destination: "London,UK",
          api_key: user.api_key
        }
      end

      it "renders an error if the email is taken", :vcr do
        post api_v0_road_trip_path,
          headers: valid_headers, params: @body, as: :json

        data = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        expect(response).to have_http_status(:created)
        expect(data[:travel_time]).to include("impossible")
        expect(data[:weather_at_eta]).to eq({})
      end
    end
  end
end

