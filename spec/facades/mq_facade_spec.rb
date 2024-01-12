require "rails_helper"

RSpec.describe MqFacade do
  describe "::get_lat_lon" do
    it "returns a hash of the mq endpoint", :vcr do
      results = MqFacade.get_lat_long("Del Norte, CO")
      expect(results).to be_a Hash
      expect(results).to have_key :status
      expect(results).to have_key :data
      expect(results[:data]).to be_a Hash
      expect(results[:data][:results]).to be_an Array
    end
  end
end
