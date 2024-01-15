require "rails_helper"

RSpec.describe User, type: :model do
  before(:each) do
    DatabaseCleaner.clean
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password_digest) }
  end

  describe "callbacks" do
    describe "#gen_api_key" do
      it "generates a new api key" do
        user = create(:user)

        expect(user).to be_a User

        attrs = attributes_for(:user)
        # create a new user with the same api key
        user2 = User.new(
          email: attrs[:email],
          password: attrs[:password],
          password_confirmation: attrs[:password_confirmation],
          api_key: user.api_key
        )
        # save methods runs the gen_api_key callback
        user2.save
        # api key will be different
        expect(user.api_key).to_not eq user2.api_key
      end
    end

    describe "#encrpyt_password" do
      it "encrypts the password" do
        user = create(:user, password: "test")
        expect(user.password_digest).to_not eq "test"
        expect(user.password_digest).to_not be_nil
        expect(BCrypt::Password.new(user.password_digest)).to eq "test"
      end

      it "raises an error if password is not present" do
        user = User.new(email: "<EMAIL>", password: nil)
        expect { user.save! }.to raise_error(Mongoid::Errors::Validations)
      end
    end
  end

  describe "email uniqueness" do
    it "should be unique" do
      user = create(:user)
      user2 = User.new(email: user.email)
      expect(user2).to_not be_valid
    end
  end
end
