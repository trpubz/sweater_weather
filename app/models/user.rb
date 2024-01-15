class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :password, type: String
  field :api_key, type: String

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :api_key, presence: true, uniqueness: true
end
