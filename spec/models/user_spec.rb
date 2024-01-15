require "rails_helper"

RSpec.describe User, type: :model do
  before(:each) do
    DatabaseCleaner.clean
  end
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:api_key) }
    it { should validate_uniqueness_of(:api_key) }
  end
end
