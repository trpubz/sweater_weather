require "rails_helper"

describe YelpApiService do
  describe "::get_businesses" do
    it "returns a list of businesses", vcr: {record: :new_episodes} do
      # 37.67, -106.35 ~ loc of Del Norte, CO
      lat_lng = MqFacade.get_lat_lng("Del Norte, CO, USA")

      businesses = YelpApiService.get_businesses(cuisine: "mexican", lat: lat_lng[:lat], lng: lat_lng[:lng])

      expect(businesses[:status]).to eq 200
      expect(businesses[:data]).to have_key :businesses
      expect(businesses[:data][:businesses]).to be_an Array
      expect(businesses[:data][:businesses].first).to have_key :name
      expect(businesses[:data][:businesses].first).to have_key :rating
      expect(businesses[:data][:businesses].first).to have_key :review_count
      expect(businesses[:data][:businesses].first).to have_key :location
      expect(businesses[:data][:businesses].first[:location]).to have_key :display_address
    end
  end
end
