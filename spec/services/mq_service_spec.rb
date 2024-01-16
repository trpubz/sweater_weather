require "rails_helper"

RSpec.describe MqService do
  context "status :ok" do
    it "creates a Faraday::Connection" do
      conn = MqService.conn
      expect(conn).to be_a(Faraday::Connection)
      expect(conn.params).to include({"key" => Rails.application.credentials.mapquest_key})
    end

    describe "::get_lat_lon" do
      it "returns a lat and lon", :vcr do
        response = MqService.get_lat_lng("Del Norte, CO")

        expect(response).to be_a(Hash)
        expect(response[:status]).to eq(200)
        expect(response[:data]).to be_a(Hash)
        expect(response[:data][:results].first[:locations].first[:latLng]).to be_a(Hash)
      end
    end

    describe "::get_directions" do
      it "returns a directions", :vcr do
        response = MqService.get_directions("Del Norte, CO, USA", "Monte Vista, CO")
        expect(response).to be_a(Hash)
        expect(response[:status]).to eq(200)
        data = response[:data]
        expect(data).to be_a(Hash)
        expect(data[:route][:time]).to be_a(Integer)
        expect(data[:route][:formattedTime]).to be_a(String)
        expect(data[:route][:locations]).to be_a(Array)
        expect(data[:route][:locations].count).to eq(2)
        expect(data[:route][:locations].first).to be_a(Hash)
        expect(data[:route][:locations].last).to be_a(Hash)
      end

      it "returns good directions for NY to LA", :vcr do
        response = MqService.get_directions("New York City, NY", "Los Angeles, CA")
        expect(response).to be_a(Hash)
        expect(response[:status]).to eq(200)
        data = response[:data]
        expect(data).to be_a(Hash)
      end

      it "returns an error if directions are not found", :vcr do
        response = MqService.get_directions("Del Norte, CO, USA", "Tromso, Norway")
        expect(response).to be_a(Hash)
        expect(response[:status]).to eq(402)
      end
    end
  end

  describe "::response_conversion" do
    it "returns a hash" do
      response = Faraday::Response.new(status: 200, body: {"test" => "test"}.to_json)
      converted = MqService.response_conversion(response)
      expect(converted).to be_a(Hash)
      expect(converted[:status]).to eq(200)
      expect(converted[:data]).to be_a(Hash)
    end
  end
end
