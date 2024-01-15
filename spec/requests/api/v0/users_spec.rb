require "rails_helper"

RSpec.describe "Api::V0::Users", type: :request do
  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController, or in your router and rack
  # middleware. Be sure to keep this updated too.
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

        @body = {
          email: "whatever@example.com",
          password: "password",
          password_confirmation: "password"
        }
      end

      it "creates a new User" do
        expect {
          post api_v0_users_path,
            headers: valid_headers, params: @body, as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post api_v0_users_path,
          headers: valid_headers, params: @body, as: :json
        expect(response).to have_http_status(:created)
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
        @body = {
          email: "whatever@example.com",
          password: "password",
          password_confirmation: "passwort"
        }
      end

      it "does not create a new User" do
        expect {
          post api_v0_users_path,
            headers: valid_headers, params: @body, as: :json
        }.to change(User, :count).by(0)
      end

      it "renders a JSON response with errors for the new user" do
        post api_v0_users_path,
          headers: valid_headers, params: @body, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "renders an error if the email is taken" do
        user = create :user
        body = {
          email: user.email,
          password: "password",
          password_confirmation: "password"
        }

        post api_v0_users_path,
          headers: valid_headers, params: body, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        message = JSON.parse(response.body, symbolize_names: true)[:error]
        expect(message).to include("Email")
      end
    end
  end
end
