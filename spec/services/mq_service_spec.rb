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
        response = MqService.get_lat_lon("Del Norte, CO")

        expect(response).to be_a(Hash)
        expect(response[:status]).to eq(200)
        expect(response[:data]).to be_a(Hash)
        expect(response[:data][:results].first[:locations].first[:latLng]).to be_a(Hash)
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
