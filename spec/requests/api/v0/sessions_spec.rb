require "rails_helper"

RSpec.describe "Api::V0::Sessions", type: :request do
  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # SessionsController, or in your router and rack middleware
  let(:valid_headers) {
    {
      "Conentent-Type" => "application/json",
      "Accept" => "application/json"
    }
  }

  describe "POST #create" do
    context "with valid parameters" do
      before :each do
        DatabaseCleaner.clean

        user = create :user
        @body = {
          email: user.email,
          password: "test"
        }
      end

      it "renders a JSON response with the new user" do
        post api_v0_sessions_path,
          headers: valid_headers, params: @body, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to eq UsersSerializer.new(User.last).to_json

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data).to have_key(:id)
        expect(data).to have_key(:type)
        expect(data[:attributes]).to have_key(:email)
        expect(data[:attributes]).to have_key(:api_key)
      end
    end

    context "with invalid parameters" do
      before :each do
        DatabaseCleaner.clean
        # passwords don't match
        @user = create :user
      end

      it "renders a JSON response for bad password" do
        body = {
          email: @user.email,
          password: "wrong"
        }
        post api_v0_sessions_path,
          headers: valid_headers, params: body, as: :json
        expect(response).to have_http_status(:not_found)
      end

      it "renders an error if the email is nonexistent" do
        body = {
          email: "wrongemail",
          password: "test"
        }
        post api_v0_sessions_path,
          headers: valid_headers, params: body, as: :json

        expect(response).to have_http_status(:not_found)
        message = JSON.parse(response.body, symbolize_names: true)[:error]
        expect(message).to include("email")
      end
    end
  end
end
