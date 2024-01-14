require "rails_helper"

RSpec.describe "Api::V1::Munchies", type: :request do
  describe "GET /munchies" do
    describe "#search" do
      it "returns a single munchie spot", :vcr do
        get "/api/v1/munchies?destination=del norte,co,usa&food=mexican"

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(response).to have_http_status(:success)
        expect(data).to have_key :type
        expect(data).to have_key :attributes
        expect(data[:attributes][:destination_city]).to eq("Del Norte, CO")
        expect(data[:attributes]).to have_key :restaurant
        expect(data[:attributes]).to have_key :forecast
        expect(data[:attributes][:forecast]).to have_key :temperature
        expect(data[:attributes][:forecast][:temperature]).to be_a Float
      end
    end
  end
end
